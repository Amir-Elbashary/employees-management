class Attendance < ApplicationRecord
  validates :checkin, presence: true

  belongs_to :employee
end
