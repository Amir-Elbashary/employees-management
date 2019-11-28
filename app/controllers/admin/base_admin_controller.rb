class Admin::BaseAdminController < ApplicationController
  before_action :authenticate
  before_action :set_entities
  layout 'dashboard'
  check_authorization

  rescue_from ActiveRecord::InvalidForeignKey do
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html do
        redirect_to admin_path, notice: 'Item can not be deleted because'\
                                        'it\'s accossiated with Points,'\
                                        'Campaign, or any other events,'\
                                        ' Please make sure you cancel'\
                                        ' them before proceeding.'
      end
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to admin_path, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def authenticate
    if current_admin
      authenticate_admin!
    elsif current_hr
      authenticate_hr!
    else
      authenticate_employee!
    end
  end

  def set_entities
    @settings = Setting.first
    @notification = Notification.new
    @notifications = current_active_user.notifications.limit(10)
    @inbox = current_active_user.received_messages.limit(10)
    @main_room = Room.find_by(name: 'Fustany Team')
    @current_attendance = current_active_user&.attendances&.where(created_at: Time.zone.now.at_beginning_of_day..Time.zone.now.at_end_of_day)&.first
    # TODO known issue where it calculates extra day
    @approved_wfh_requests = current_employee&.vacation_requests&.work_from_home&.approved&.where("? BETWEEN starts_on AND ends_on", Date.today)

    @pending_requests = if current_admin
                          VacationRequest.where(status: %w[pending confirmed escalated])
                        elsif current_hr
                          VacationRequest.where(status: %w[confirmed escalated])
                        elsif current_employee&.supervisor?
                          VacationRequest.where(requester: current_employee.employees, status: 'pending')
                        elsif current_employee&.employee?
                          current_employee.vacation_requests.pending
                        end

    current_time = Time.zone.now
    start_time = @current_attendance ? @current_attendance.checkin : 0

    @time_spent_today = @current_attendance ? ((current_time - start_time) / 60 / 60).round(2) : 0 
    @time_spent_percentage = @current_attendance ? ((((current_time - start_time) / 60 / 60).round(2)) / 8 * 100).round(2) : 0

    @hours_spent_this_month = current_active_user&.attendances&.where(created_at: Time.zone.now.at_beginning_of_month..Time.zone.now.at_end_of_month).pluck(:time_spent)&.inject(:+)&.round(2) || 0

    @progress_color = if @time_spent_percentage < 50
                        'danger'
                      elsif @time_spent_percentage.between?(50, 90)
                        'info'
                      elsif @time_spent_percentage > 90
                        'success'
                      end
  end
end
