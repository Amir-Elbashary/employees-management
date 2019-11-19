class PerformanceTopic < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }
end
