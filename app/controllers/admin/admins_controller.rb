class Admin::AdminsController < Admin::BaseAdminController
  load_and_authorize_resource except: %i[dashboard edit update toggle_state]
  skip_authorization_check only: %i[dashboard edit update toggle_state]

  def dashboard
    render 'admin/dashboard'
  end

  # def edit; end

  # def update
  #   current_active_role = current_admin || current_supervisor

  #   if current_active_role.update(admin_params)
  #     if params[:admin] && params[:admin][:avatar].present? || params[:supervisor] && params[:supervisor][:avatar].present?
  #       render :crop ## Render the view for cropping
  #     else
  #       flash[:notice] = 'Your info has been successfully updated.'
  #       redirect_to admin_path
  #     end
  #   else
  #     render 'edit'
  #   end
  # end

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

  # def admin_params
  #   if current_admin
  #     if params[:admin][:password].present?
  #       params.require(:admin).permit(:password, :password_confirmation,
  #                                     :first_name, :last_name, :phone_number,
  #                                     :bio, :avatar,
  #                                     :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
  #     else
  #       params.require(:admin).permit(:first_name, :last_name,
  #                                     :phone_number, :bio, :avatar,
  #                                     :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
  #     end
  #   elsif current_supervisor
  #     if params[:supervisor][:password].present?
  #       params.require(:supervisor).permit(:password, :password_confirmation, :first_name,
  #                                          :last_name, :phone_number, :avatar,
  #                                          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
  #     else
  #       params.require(:supervisor).permit(:first_name, :last_name, :phone_number, :avatar,
  #                                          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
  #     end
  #   end
  # end
end
