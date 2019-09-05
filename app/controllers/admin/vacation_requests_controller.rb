class Admin::VacationRequestsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :set_vacation_requests, only: :index
  before_action :ensure_hr_or_supervisor, only: :pending
  before_action :set_pending_requests, only: :pending
  before_action :ensure_same_employee, only: :edit
  before_action :validate_dates, only: %i[create update]

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
    @vacation_request.approved!

    employee = @vacation_request.employee
    vacation_duration = (@vacation_request.ends_on - @vacation_request.starts_on).to_i

    employee.update(vacation_balance: employee.vacation_balance.to_i - vacation_duration)
    redirect_to pending_admin_vacation_requests_path
  end

  def decline
    @vacation_request.declined!
    redirect_to pending_admin_vacation_requests_path
  end

  private

  def vacation_request_params
    params.require(:vacation_request).permit(:employee_id, :hr_id, :supervisor_id,
                                             :starts_on, :ends_on, :reason,
                                             :supervisor_feedback, :hr_feedback, :escalation_reason)
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

  def validate_dates
    return unless params[:vacation_request][:starts_on].present? || params[:vacation_request][:ends_on].present?
    return if params[:vacation_request][:starts_on] < params[:vacation_request][:ends_on]
    flash[:danger] = 'End date can not be before start date.'
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
end
