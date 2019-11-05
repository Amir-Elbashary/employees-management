class Hr < ApplicationRecord
  include UserHelpers
  enum gender: %i[unspecified male female]
  enum work_type: %i[full_time part_time freelance]
  enum marital_status: %i[single engaged married]
  enum military_status: %i[completed exemption postponed currently_serving does_not_apply]
  mount_uploader :avatar, AvatarUploader
  # crop_uploaded :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  has_many :hr_roles, dependent: :destroy
  has_many :roles, through: :hr_roles
  has_many :notifications, as: :recipient
  has_many :comments, dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', as: :sender
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id', as: :recipient
  has_many :attendances, dependent: :destroy
  has_many :vacation_requests, dependent: :destroy
end
