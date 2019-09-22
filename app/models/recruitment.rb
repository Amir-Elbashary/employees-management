class Recruitment < ApplicationRecord
  include UserHelpers
  enum decision: %i[pending shortlisted hired not_hired]

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false  }
end
