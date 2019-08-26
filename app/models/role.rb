class Role < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  has_many :hr_roles, dependent: :destroy
  has_many :hrs, through: :hr_roles
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions
end
