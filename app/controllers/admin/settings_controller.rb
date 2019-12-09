class Admin::SettingsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_settings, only: %i[dashboard update]

  def dashboard; end

  def refresh_permissions
    @added_permissions = 0

    generate_main_actions
    generate_custom_actions

    flash[:notice] = "Permissions refreshed successfully, #{@added_permissions} permissions added"
    redirect_to dashboard_admin_settings_path
  end

  def update
    if @settings.update(settings_params)
      flash[:notice] = 'Settings updated'
    else
      flash[:danger] = @settings.errors.full_messages.join(', ')
    end
    redirect_to dashboard_admin_settings_path
  end

  private

  def settings_params
    params.require(:setting).permit(:work_from_home, :send_attendance_summary, :send_checkout_reminder,
                                    :checkout_reminder_minutes, :add_remaining_checkout_time, ip_addresses: [])
  end

  def set_settings
    @settings = Setting.first
  end

  def generate_main_actions
    Ability::AUTHORIZABLE_MODELS.each do |model|
      %w[create read update destroy].map do |action|
        next if Permission.where(target_model_name: model.name, action: action).any?
        Permission.create(target_model_name: model.name, action: action)
        @added_permissions += 1
      end
    end
  end

  def generate_custom_actions
    custom_actions = {
      'Admin' => %w[change_password],
      'Employee' => %w[resend_mail toggle_state toggle_level announce_birthday],
      'Attendance' => %w[grant revoke checkin checkout remote_checkout append reports],
      'VacationRequest' => %w[pending approve decline],
      'Update' => %w[reset_ip]
    }

    custom_actions.map do |model, actions|
      actions.map do |action|
        next if Permission.where(target_model_name: model, action: action).any?
        Permission.create(target_model_name: model, action: action)
        @added_permissions += 1
      end
    end
  end
end
