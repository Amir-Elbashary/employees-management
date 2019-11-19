class Performance < ApplicationRecord
  validate :unique_performance_for_employee, on: :create
  validates :year, :month, :topic, :score, presence: true
  validates :topic, uniqueness: { case_sensitive: false, scope: [:employee_id, :year, :month] }

  belongs_to :employee

  def unique_performance_for_employee
    errors.add(:base, 'Performance on same period already exists') if Performance.where(employee_id: self.employee_id, topic: self.topic, year: self.year, month: self.month).any?
  end
end
