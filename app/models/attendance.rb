class Attendance < ApplicationRecord
  validates :checkin, presence: true

  belongs_to :attender, polymorphic: true

  default_scope { order(checkin: :desc) }
end
