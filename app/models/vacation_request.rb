class VacationRequest < ApplicationRecord
  enum status: %i[pending confirmed refused escalated approved declined]

  validates :starts_on, :ends_on, :reason, presence: true

  belongs_to :employee
  belongs_to :hr, optional: true
  belongs_to :supervisor, class_name: 'Employee', foreign_key: 'supervisor_id', optional: true

  default_scope { order(id: :asc) }
end
