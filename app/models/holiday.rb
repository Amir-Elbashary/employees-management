class Holiday < ApplicationRecord
  validate :unique_holiday
  validates :name, :content, :year, :month,
            :duration, :starts_on, presence: true

  def unique_holiday
    errors.add(:base, 'Holiday already exists') if Holiday.where(year: year, month: month, starts_on: starts_on).any?
  end
end
