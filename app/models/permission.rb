class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions

  def name
    crud = %w[create read update destroy]
    if crud.include?(action)
      "Can #{action.titleize} #{target_model_name}"
    else
      "#{action.titleize} #{target_model_name}"
    end
  end
end
