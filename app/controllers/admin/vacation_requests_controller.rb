class Admin::VacationRequestsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :set_vacation_requests, only: :index
  before_action :ensure_hr_or_supervisor, only: :pending
  before_action :set_pending_requests, only: :pending
  before_action :ensure_same_employee, only: :edit
  before_action :validate_dates, only: %i[create update]
  before_action :validate_times, only: %i[create update]
  before_action :set_settings, only: :approve
  before_action :set_requester, only: :approve

  def new; end

  def create
    if @vacation_request.save
      flash[:notice] = 'Request has been submitted.'
      redirect_to admin_vacation_requests_path
      VacationRequest::NewRequestNotifierWorker.perform_async(@vacation_request.id)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @vacation_request.update(vacation_request_params)
      flash[:notice] = 'Request has been updated.'
      redirect_to admin_vacation_requests_path
    else
      render 'edit'
    end
  end

  def index; end

  def destroy
    return unless @vacation_request.destroy
    flash[:notice] = 'Request was deleted.'
    redirect_to admin_vacation_requests_path
  end

  def pending; end

  def escalation; end

  def escalate
    return unless @vacation_request.update(vacation_request_params)
    return unless @vacation_request.escalated!
    redirect_to admin_vacation_requests_path
    VacationRequest::EscalationNotifierWorker.perform_async(@vacation_request.id)
  end

  def confirm
    return unless @vacation_request.confirmed!
    redirect_to pending_admin_vacation_requests_path
    VacationRequest::SupervisorConfirmNotifierWorker.perform_async(@vacation_request.id)
    VacationRequest::HrPendingApproveNotifierWorker.perform_async(@vacation_request.id)
  end

  def refuse
    return unless @vacation_request.refused!
    redirect_to pending_admin_vacation_requests_path
    VacationRequest::SupervisorRefuseNotifierWorker.perform_async(@vacation_request.id)
  end

  def approve
    if @vacation_request.vacation?
      approve_vacation if @requester.update(vacation_balance: @requester.vacation_balance - @vacation_request.duration)
    end
    approve_sick_leave if @vacation_request.sick_leave?
    approve_mission if @vacation_request.mission?
    approve_wfh if @vacation_request.work_from_home?

    redirect_to pending_admin_vacation_requests_path
  end

  def decline
    return unless @vacation_request.declined!
    redirect_to pending_admin_vacation_requests_path
    VacationRequest::HrDeclineNotifierWorker.perform_async(current_active_user.id, @vacation_request.id)
  end

  private

  def vacation_request_params
    params.require(:vacation_request).permit(:requester_id, :requester_type, :starts_on, :ends_on,
                                             :starts_at, :ends_at, :reason, :kind, :supervisor_feedback,
                                             :hr_feedback, :escalation_reason)
  end

  def set_vacation_requests
    @vacation_requests = current_active_user.vacation_requests
  end

  def set_pending_requests
    @vacation_requests = if current_hr
                           VacationRequest.all
                         else
                           VacationRequest.where(requester: current_employee.employees)
                         end
  end

  def set_settings
    @settings = Setting.first
    @work_from_home_days = @settings.work_from_home
  end

  def set_requester
    @requester = @vacation_request.requester
  end

  def validate_dates
    return if params[:vacation_request][:kind] == 'mission'
    return if date_params_exist?
    return if valid_date_params?
    flash[:danger] = 'End date can not be before or equals to start date.'
    redirect_to new_admin_vacation_request_path
  end

  def validate_times
    return unless params[:vacation_request][:kind] == 'mission'
    return if time_params_exist?
    return if valid_time_params?
    flash[:danger] = 'End time can not be before or equals start time.'
    redirect_to new_admin_vacation_request_path
  end

  def date_params_exist?
    return true unless params[:vacation_request][:starts_on].present? || params[:vacation_request][:ends_on].present?
  end

  def valid_date_params?
    return true if params[:vacation_request][:starts_on] < params[:vacation_request][:ends_on]
    false
  end

  def time_params_exist?
    return true unless params[:vacation_request][:starts_at].present? || params[:vacation_request][:ends_at].present?
  end

  def valid_time_params?
    return true if params[:vacation_request][:starts_at] < params[:vacation_request][:ends_at]
  end

  def ensure_same_employee
    return if @vacation_request.requester == current_employee
    flash[:danger] = 'You are not allowed!'
    redirect_to admin_vacation_requests_path
  end

  def ensure_hr_or_supervisor
    return if current_hr || current_employee.supervisor?
    flash[:danger] = 'You are not allowed!'
    redirect_to admin_vacation_requests_path
  end

  def create_timeline_post(content)
    Timeline.create(publisher: @vacation_request.requester,
                    images: [@vacation_request.requester.profile_pic],
                    kind: 'news',
                    creation: 'auto',
                    content: content)
  end

  def approve_vacation
    flash[:notice] = 'Vacation request Approved.'
    if @vacation_request.approved!
      VacationRequest::HrApproveNotifierWorker.perform_async(current_active_user.id,
                                                             @vacation_request.id)
    end

    create_timeline_post(vacation_post_content)
  end

  def approve_sick_leave
    flash[:notice] = 'Sick leave request approved.'
    if @vacation_request.approved!
      VacationRequest::HrApproveNotifierWorker.perform_async(current_active_user.id,
                                                             @vacation_request.id)
    end

    create_timeline_post(sick_leave_post_content)
  end

  def approve_wfh
    @request_duration = @vacation_request.duration_without_weekends
    wfh_requests = @requester.vacation_requests
                             .where(created_at: Time.zone.now.at_beginning_of_month..Time.zone.now.at_end_of_month)
                             .approved.work_from_home
    @days_taken = 0

    wfh_requests.each do |request|
      @days_taken += request.duration
    end

    process_wfh_request
  end

  def process_wfh_request
    process_invalid_request

    process_valid_request if (@days_taken + @request_duration) <= @work_from_home_days
  end

  def process_invalid_request
    if @request_duration > @work_from_home_days
      flash[:notice] = 'Request duration is longer than the allowed limit of days.'
    elsif @days_taken >= @work_from_home_days
      flash[:danger] = 'Work from home limit reached for this employee.'
    elsif (@days_taken + @request_duration) > @work_from_home_days
      flash[:danger] = 'Not enough work from home days left for this employee.'
    end
  end

  def process_valid_request
    flash[:notice] = 'Work from home request approved.'
    if @vacation_request.approved!
      VacationRequest::HrApproveNotifierWorker.perform_async(current_active_user.id,
                                                             @vacation_request.id)
    end

    create_timeline_post(wfh_post_content)
  end

  def approve_mission
    if @vacation_request.approved!
      VacationRequest::HrApproveNotifierWorker.perform_async(current_active_user.id,
                                                             @vacation_request.id)
    end

    flash[:notice] = 'Mission request approved.'
  end

  def vacation_post_content
    "<p><strong>#{@vacation_request.requester.name} is going to have a vacation :smiley:</strong></p>
    <p><strong>&nbsp;&nbsp;</strong>#{@vacation_request.requester.first_name} will be off from <strong>
    #{formatted_date(@vacation_request.starts_on)}</strong> to <strong>
    #{formatted_date(@vacation_request.ends_on)}</strong>
    , as #{he_she(@vacation_request.requester)} is going to be on a refreshing vacation
    , We are wishing #{him_her(@vacation_request.requester)} happy time. :wink:</p>
    <p><strong>Best wishes,</strong><br><strong>Fustany Team</strong></p>"
  end

  def sick_leave_post_content
    "<p><strong>#{@vacation_request.requester.name} is not feeling well :pensive:</strong></p>
    <p><strong>&nbsp;&nbsp;</strong>
    We're sorry to hear that #{@vacation_request.requester.first_name} will be off from <strong>
    #{formatted_date(@vacation_request.starts_on)}</strong> to <strong>
    #{formatted_date(@vacation_request.ends_on)}</strong>
    , as #{he_she(@vacation_request.requester)} is not feeling well
    , The little flowers are rising and blooming; it&rsquo;s the world&rsquo;s way of saying
    , &ldquo;get well soon.&rdquo; :pray:</p>
    <p><strong>Best wishes,</strong><br><strong>Fustany Team</strong></p>"
  end

  def wfh_post_content
    "<p><strong>#{@vacation_request.requester.name} will be working from home!</strong></p>
    <p><strong>&nbsp;&nbsp;</strong>#{@vacation_request.requester.first_name} will be working from home from <strong>
    #{formatted_date(@vacation_request.starts_on)}</strong> to <strong>
    #{formatted_date(@vacation_request.ends_on)}</strong>
    , You can reach #{him_her(@vacation_request.requester)} on Slack!</p>
    <p><strong>Best regards,</strong><br><strong>Fustany Team</strong></p>"
  end
end
