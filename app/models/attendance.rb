class Attendance < ApplicationRecord
  validates :checkin, presence: true

  belongs_to :admin, optional: true
  belongs_to :hr, optional: true
  belongs_to :employee, optional: true

  default_scope { order(created_at: :asc) }
end
