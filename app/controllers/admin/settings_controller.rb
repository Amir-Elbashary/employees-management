class Admin::SettingsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource

  def dashboard; end

  def refresh_permissions
    custom_actions = { 'Employee' => ['toggle_level'] }

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
end
