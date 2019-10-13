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

  def new; end

  def create
    if @vacation_request.save
      flash[:notice] = 'Request has been submitted.'
      redirect_to admin_vacation_requests_path
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
    @vacation_request.escalated!
    redirect_to admin_vacation_requests_path
  end

  def confirm
    @vacation_request.confirmed!
    redirect_to pending_admin_vacation_requests_path
  end

  def refuse
    @vacation_request.refused!
    redirect_to pending_admin_vacation_requests_path
  end

  def approve
    employee = @vacation_request.employee
    work_from_home_days = @settings.work_from_home

    if @vacation_request.vacation?
      vacation_duration = (@vacation_request.ends_on - @vacation_request.starts_on).to_i
      if employee.update(vacation_balance: employee.vacation_balance.to_i - vacation_duration)
        flash[:notice] = 'Vacation request Approved.'
        @vacation_request.approved!

        content = "<p><strong>#{@vacation_request.employee.full_name} is going to have a vacation :)</strong></p>
        <p><strong>&nbsp;&nbsp;</strong>#{@vacation_request.employee.first_name} will be off from <strong>#{formatted_date(@vacation_request.starts_on)}</strong> to <strong>#{formatted_date(@vacation_request.ends_on)}</strong>, as #{he_she(@vacation_request.employee)} is going to be on a refreshing vacation, We are wishing #{him_her(@vacation_request.employee)} happy time and we will be missing #{him_her(@vacation_request.employee)}</p>
        <p><strong>Best wishes,</strong><br><strong>Fustany Team</strong></p>"

        create_timeline_post(content)
      end
    end

    if @vacation_request.sick_leave?
      flash[:notice] = 'Sick leave request approved.'
      @vacation_request.approved!

      content = "<p><strong>#{@vacation_request.employee.full_name} is not feeling well :(</strong></p>
      <p><strong>&nbsp;&nbsp;</strong>We're sorry to hear that #{@vacation_request.employee.first_name} will be off from <strong>#{formatted_date(@vacation_request.starts_on)}</strong> to <strong>#{formatted_date(@vacation_request.ends_on)}</strong>, as #{he_she(@vacation_request.employee)} is not feeling well, The little flowers are rising and blooming; it&rsquo;s the world&rsquo;s way of saying, &ldquo;get well soon.&rdquo;</p>
      <p><strong>Best wishes,</strong><br><strong>Fustany Team</strong></p>"

      create_timeline_post(content)
    end

    if @vacation_request.mission?
      flash[:notice] = 'Mission request approved.'
      @vacation_request.approved!
    end

    if @vacation_request.work_from_home?
      request_duration = (@vacation_request.ends_on - @vacation_request.starts_on).to_i
      work_from_home_requests = employee.vacation_requests.where(created_at: Time.zone.now.at_beginning_of_month..Time.zone.now.at_end_of_month).approved.work_from_home
      days_taken = 0

      work_from_home_requests.each do |request|
        duration = (request.ends_on - request.starts_on).to_i
        days_taken += duration
      end

      if request_duration > work_from_home_days
        flash[:notice] = 'Request duration is longer than the allowed limit of days.'
      elsif days_taken >= work_from_home_days
        flash[:danger] = 'Work from home limit reached for this employee.'
      elsif (days_taken + request_duration) > work_from_home_days
        flash[:danger] = 'Not enough work from home days left for this employee.'
      elsif (days_taken + request_duration) <= work_from_home_days
        flash[:notice] = 'Work from home request approved.'
        @vacation_request.approved!

        content = "<p><strong>#{@vacation_request.employee.full_name} will be working from home!</strong></p>
        <p><strong>&nbsp;&nbsp;</strong>#{@vacation_request.employee.first_name} will be working from home from <strong>#{formatted_date(@vacation_request.starts_on)}</strong> to <strong>#{formatted_date(@vacation_request.ends_on)}</strong>, You can reach #{him_her(@vacation_request.employee)} on Slack!, we will be missing #{him_her(@vacation_request.employee)}</p>
        <p><strong>Best regards,</strong><br><strong>Fustany Team</strong></p>"

        create_timeline_post(content)
      end
    end

    redirect_to pending_admin_vacation_requests_path
  end

  def decline
    @vacation_request.declined!
    redirect_to pending_admin_vacation_requests_path
  end

  private

  def vacation_request_params
    params.require(:vacation_request).permit(:employee_id, :hr_id, :supervisor_id,
                                             :starts_on, :ends_on, :starts_at, :ends_at,
                                             :reason, :kind, :supervisor_feedback, :hr_feedback,
                                             :escalation_reason)
  end

  def set_vacation_requests
    @vacation_requests = current_employee.vacation_requests
  end

  def set_pending_requests
    @vacation_requests = if current_hr
                           VacationRequest.all
                         else
                           VacationRequest.where(employee: current_employee.employees)
                         end
  end

  def set_settings
    @settings = Setting.first
  end

  def validate_dates
    return if params[:vacation_request][:kind] == 'mission'
    return unless params[:vacation_request][:starts_on].present? || params[:vacation_request][:ends_on].present?
    return if params[:vacation_request][:starts_on] < params[:vacation_request][:ends_on]
    flash[:danger] = 'End date can not be before or equals to start date.'
    redirect_to new_admin_vacation_request_path
  end

  def validate_times
    return unless params[:vacation_request][:kind] == 'mission'
    return unless params[:vacation_request][:starts_at].present? || params[:vacation_request][:ends_at].present?
    return if params[:vacation_request][:starts_at] < params[:vacation_request][:ends_at]
    flash[:danger] = 'End time can not be before or equals start time.'
    redirect_to new_admin_vacation_request_path
  end

  def ensure_same_employee
    return if @vacation_request.employee == current_employee
    flash[:danger] = 'You are not allowed!'
    redirect_to admin_vacation_requests_path
  end

  def ensure_hr_or_supervisor
    return if current_hr || current_employee.supervisor?
    flash[:danger] = 'You are not allowed!'
    redirect_to admin_vacation_requests_path
  end

  def create_timeline_post(content)
    Timeline.create(employee: @vacation_request.employee,
                    images: [@vacation_request.employee.profile_pic],
                    kind: 'news',
                    creation: 'auto',
                    content: content)
  end
end
