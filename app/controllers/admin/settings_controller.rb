class Admin::SettingsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_settings, only: %i[dashboard update]

  def dashboard; end

  def refresh_permissions
    custom_actions = { 'Admin' => %w[change_password],
                       'Employee' => %w[resend_mail toggle_level],
                       'Attendance' => %w[grant revoke],
                       'VacationRequest' => %w[pending approve decline] }

    added_permissions = 0

    Ability::AUTHORIZABLE_MODELS.each do |model|
      %w[create read update destroy].map do |action|
        next if Permission.where(target_model_name: model.name, action: action).any?
        Permission.create(target_model_name: model.name, action: action)
        added_permissions += 1
      end
    end

    custom_actions.map do |model, actions|
      actions.map do |action|
        next if Permission.where(target_model_name: model, action: action).any?
        Permission.create(target_model_name: model, action: action)
        added_permissions += 1
      end
    end

    flash[:notice] = "Permissions refreshed successfully, #{added_permissions} permissions added"
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
    params.require(:setting).permit(ip_addresses: [])
  end

  def set_settings
    @settings = Setting.first
  end
end
