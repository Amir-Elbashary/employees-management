class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_active_user, :current_ability
  skip_before_action :verify_authenticity_token, only: :reorder

	def current_active_user      
    current_admin || current_hr || current_employee
  end
  
  def current_ability
    if request.fullpath =~ /\/admin/
      @current_ability ||= Ability.new(current_admin || current_hr)
    else
      @current_ability ||= Ability.new(current_employee)
    end
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
end
