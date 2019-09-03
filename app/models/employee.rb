class Employee < ApplicationRecord
  include UserHelpers
  enum gender: %i[unspecified male female]
  enum work_type: %i[full_time part_time freelance]
  enum marital_status: %i[single engaged married]
  enum military_status: %i[completed exemption postponed currently_serving does_not_apply]
  enum level: %i[employee supervisor]
  mount_uploader :avatar, AvatarUploader
  crop_uploaded :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  has_many :employees, class_name: 'Employee', foreign_key: 'supervisor_id'
  has_many :documents, dependent: :destroy
  has_many :vacation_requests, dependent: :destroy
  has_many :room_messages, dependent: :destroy
  belongs_to :supervisor, class_name: 'Employee', foreign_key: 'supervisor_id', optional: true
  belongs_to :section, optional: true

  accepts_nested_attributes_for :documents, allow_destroy: true,
                                            reject_if: ->(a) { a[:name].blank? }
end
