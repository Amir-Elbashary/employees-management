class Admin::AdminsController < Admin::BaseAdminController
  load_and_authorize_resource except: %i[dashboard edit update toggle_state]
  skip_authorization_check only: %i[dashboard edit update toggle_state]

  def dashboard
    render 'admin/dashboard'
  end

  def edit; end

  def update
    current_active_role = current_admin || current_hr

    if current_active_role.update(admin_params)
      if params[:admin] && params[:admin][:avatar].present? || params[:hr] && params[:hr][:avatar].present?
        render :crop ## Render the view for cropping
      else
        flash[:notice] = 'Your info has been successfully updated.'
        redirect_to admin_path
      end
    else
      render 'edit'
    end
  end

  # def toggle_state
  #   unless can? :toggle, params[:model].constantize
  #     flash[:notice] = 'You are not authorized to perform this action'
  #     return redirect_back(fallback_location: request.referer)
  #   end

  #   object = params[:model].constantize.find(params[:id])

  #   if object.active?
  #     object.inactive!
  #   else
  #     object.active!
  #   end
  # end

  private

  def admin_params
    if current_admin
      if params[:admin][:password].present?
        params.require(:admin).permit(:password, :password_confirmation,
                                      :first_name, :last_name, :nationality, :marital_status,
                                      :military_status, :gender, :birthdate, :mobile_numbers,
                                      :landline_numbers, :address, :social_id, :personal_email,
                                      :business_email, :qualification, :graduation_year,
                                      :date_of_employment, :job_description, :work_type,
                                      :vacation_balance, :date_of_social_insurance_joining,
                                      :social_insurance_number, :avatar,
                                      :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
      else
        params.require(:admin).permit(:first_name, :last_name, :nationality, :marital_status,
                                      :military_status, :gender, :birthdate, :mobile_numbers,
                                      :landline_numbers, :address, :social_id, :personal_email,
                                      :business_email, :qualification, :graduation_year,
                                      :date_of_employment, :job_description, :work_type,
                                      :vacation_balance, :date_of_social_insurance_joining,
                                      :social_insurance_number, :avatar,
                                      :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
      end
    elsif current_hr
      if params[:hr][:password].present?
        params.require(:hr).permit(:password, :password_confirmation,
                                   :first_name, :last_name, :nationality, :marital_status,
                                   :military_status, :gender, :birthdate, :mobile_numbers,
                                   :landline_numbers, :address, :social_id, :personal_email,
                                   :business_email, :qualification, :graduation_year,
                                   :date_of_employment, :job_description, :work_type,
                                   :vacation_balance, :date_of_social_insurance_joining,
                                   :social_insurance_number, :avatar,
                                   :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
      else
        params.require(:hr).permit(:first_name, :last_name, :nationality, :marital_status,
                                   :military_status, :gender, :birthdate, :mobile_numbers,
                                   :landline_numbers, :address, :social_id, :personal_email,
                                   :business_email, :qualification, :graduation_year,
                                   :date_of_employment, :job_description, :work_type,
                                   :vacation_balance, :date_of_social_insurance_joining,
                                   :social_insurance_number, :avatar,
                                   :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
      end
    end
  end
end
