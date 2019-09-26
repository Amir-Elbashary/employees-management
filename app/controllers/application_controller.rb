class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  helper_method :current_active_user, :current_ability
  skip_before_action :verify_authenticity_token, only: :reorder
  before_action :set_timezone

  def current_active_user
    current_admin || current_hr || current_employee
  end

  def current_ability
    @current_ability ||= Ability.new(current_active_user)
  end

  def after_sign_out_path_for(resource)
    case resource
    when :admin
      new_admin_session_path
    when :hr
      new_hr_session_path
    when :employee
      new_employee_session_path
    end
  end

  def after_sign_in_path_for(user)
    case user
    when current_admin, current_hr, current_employee
      stored_location_for(user) || admin_path
    end
  end

  def set_timezone
    Time.zone = 'Africa/Cairo'
  end
end
