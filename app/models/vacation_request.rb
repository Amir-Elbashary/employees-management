class VacationRequest < ApplicationRecord
  enum status: %i[pending confirmed refused escalated approved declined]
  enum kind: %i[vacation work_from_home sick_leave mission]
  before_save :calculate_duration, on: %[create update]

  validates :starts_on, :ends_on, :reason, presence: true

  belongs_to :employee
  belongs_to :hr, optional: true
  belongs_to :supervisor, class_name: 'Employee', foreign_key: 'supervisor_id', optional: true

  default_scope { order(id: :desc) }

  def calculate_duration
    # Set date range
    range = starts_on..ends_on
    # Generate array of range days
    days = range.map { |d| d.strftime('%a') }
    # Remove last day to get actual duration
    days = days.reverse.drop(1).reverse
    # Remove weekend days from the calculation
    days = days - ["Fri", "Sat"]
    # Set duration for the request
    self.duration = days.size
  end
end
