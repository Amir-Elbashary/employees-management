class Admin::AdminsController < Admin::BaseAdminController
  load_and_authorize_resource except: %i[dashboard edit update toggle_state]
  skip_authorization_check only: %i[dashboard edit update toggle_state]
  before_action :set_timelines, only: :dashboard
  before_action :set_comments, only: :dashboard
  before_action :set_performances, only: :dashboard
  # before_action :set_update, only: :dashboard

  def dashboard
    render 'admin/dashboard'
  end

  def edit; end

  def update
    current_active_role = current_admin || current_hr

    if current_active_role.update(admin_params)
      flash[:notice] = 'your info has been successfully updated.'
      redirect_to admin_path
    else
      render 'edit'
    end
  end

  # Update with image cropper
  # def update
  #   current_active_role = current_admin || current_hr
  #
  #   if current_active_role.update(admin_params)
  #     if params[:admin] && params[:admin][:avatar].present? || params[:hr] && params[:hr][:avatar].present?
  #       render :crop ## render the view for cropping
  #     else
  #       flash[:notice] = 'your info has been successfully updated.'
  #       redirect_to admin_path
  #     end
  #   else
  #     render 'edit'
  #   end
  # end

  def change_password
    if current_active_user.update_with_password(password_params)
      flash[:notice] = 'Password has been changed, Please re-login'
    else
      flash[:danger] = current_active_user.errors.full_messages.join(', ')
    end
    redirect_to admin_path
  end

  def change_profile_pic
    if current_active_user.update(avatar: params[:avatar])
      flash[:notice] = 'Profile picture has been updated'
    else
      flash[:danger] = current_active_user.errors.full_messages.join(', ')
    end
    redirect_to admin_path
  end

  def updates_tracker
    return unless current_active_user.update(last_update: params[:current_version])
    redirect_to admin_path
  end

  private

  def password_params
    params.permit(:current_password, :password, :password_confirmation)
  end

  def set_timelines
    @timeline = Timeline.new
    @timelines = Timeline.paginate(page: params[:page], per_page: 10)
  end

  def set_comments
    @comment = Comment.new
  end

  def set_performances
    @performances = current_employee&.performances&.where(year: Time.zone.now.year, month: Time.zone.now.month)
    return unless current_employee
    @performances_score = (PerformanceTopic.count * 5)
    @total_score = @performances.pluck(:score).inject(:+)
  end

  # def set_update
  #   @last_update = Update.last
  #   @current_version = @last_update&.version
  #   @user_last_update = current_active_user.last_update
  # end

  def admin_params
    if current_admin
      update_model_attributes(:admin)
    elsif current_hr
      update_model_attributes(:hr)
    end
  end

  def update_model_attributes(model)
    if params[model][:password].present?
      model_params_with_password(model)
    else
      model_params_without_password(model)
    end
  end

  def model_params_with_password(model)
    params.require(model).permit(:password, :password_confirmation,
                                 :first_name, :middle_name, :last_name, :nationality, :marital_status,
                                 :military_status, :gender, :birthdate, :mobile_numbers,
                                 :landline_numbers, :address, :social_id, :personal_email,
                                 :business_email, :qualification, :graduation_year,
                                 :date_of_employment, :job_description, :work_type,
                                 :vacation_balance, :date_of_social_insurance_joining,
                                 :social_insurance_number, :avatar,
                                 :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
  end

  def model_params_without_password(model)
    params.require(model).permit(:first_name, :middle_name, :last_name, :nationality, :marital_status,
                                 :military_status, :gender, :birthdate, :mobile_numbers,
                                 :landline_numbers, :address, :social_id, :personal_email,
                                 :business_email, :qualification, :graduation_year,
                                 :date_of_employment, :job_description, :work_type,
                                 :vacation_balance, :date_of_social_insurance_joining,
                                 :social_insurance_number, :avatar,
                                 :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
  end
end
