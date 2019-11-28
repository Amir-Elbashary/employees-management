class Employee < ApplicationRecord
  include UserHelpers
  enum gender: %i[unspecified male female]
  enum work_type: %i[full_time part_time freelance]
  enum marital_status: %i[single engaged married]
  enum military_status: %i[completed exemption postponed currently_serving does_not_apply]
  enum level: %i[employee supervisor]
  enum access_token_status: %i[waiting_for_token token_verified]
  mount_uploader :photo, AvatarUploader
  mount_uploader :avatar, AvatarUploader
  # crop_uploaded :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validates :display_name, uniqueness: { case_sensitive: false }, on: :update_profile

  has_many :performances, dependent: :destroy
  has_many :notifications, as: :recipient
  has_many :timelines, class_name: 'Timeline', foreign_key: 'publisher_id', as: :publisher, dependent: :destroy
  has_many :comments, class_name: 'Comment', foreign_key: 'commenter_id', as: :commenter, dependent: :destroy
  has_many :reacts, class_name: 'React', foreign_key: 'reactor_id', as: :reactor
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', as: :sender
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id', as: :recipient
  has_many :employees, class_name: 'Employee', foreign_key: 'supervisor_id'
  has_many :documents, dependent: :destroy
  has_many :attendances, class_name: 'Attendance', foreign_key: 'attender_id', as: :attender, dependent: :destroy
  has_many :vacation_requests, class_name: 'VacationRequest', foreign_key: 'requester_id',
                               as: :requester, dependent: :destroy
  has_many :room_messages, dependent: :destroy
  belongs_to :supervisor, class_name: 'Employee', foreign_key: 'supervisor_id', optional: true
  belongs_to :section, optional: true

  accepts_nested_attributes_for :documents, allow_destroy: true,
                                            reject_if: ->(a) { a[:name].blank? }
end
