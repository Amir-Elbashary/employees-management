class Recruitment < ApplicationRecord
  include UserHelpers
  mount_uploader :cv, DocumentUploader
  enum decision: %i[pending shortlisted hired not_hired]

  validates :first_name, :last_name, :email, :mobile_number, presence: true
  validates :email, :mobile_number, uniqueness: { case_sensitive: false }
end
