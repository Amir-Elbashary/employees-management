class Admin::BaseAdminController < ApplicationController
  before_action :authenticate
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
      redirect_to new_admin_session_path
    end
  end
end
