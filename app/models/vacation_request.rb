class VacationRequest < ApplicationRecord
  enum status: %i[pending confirmed refused escalated approved declined]
  enum kind: %i[vacation work_from_home sick_leave mission]
  before_save :calculate_duration, on: %i[create update]

  validates :starts_on, :ends_on, :reason, presence: true

  belongs_to :requester, polymorphic: true

  default_scope { order(id: :desc) }

  def requested_days
    # Set date range
    range = starts_on..ends_on
    # Generate array of range days
    days = range.map { |d| d.strftime('%a') }
    # Remove last day to get actual days array
    days.reverse.drop(1).reverse
  end

  def duration_with_weekends
    requested_days.size
  end

  def duration_without_weekends
    (requested_days - %w[Fri Sat]).size
  end

  def calculate_duration
    self.duration = duration_without_weekends
  end
end
