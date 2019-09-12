class Attendance < ApplicationRecord
  validates :checkin, presence: true

  belongs_to :employee

  default_scope { order(created_at: :asc) }
end
