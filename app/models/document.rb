class Document < ApplicationRecord
  mount_uploader :file, DocumentUploader

  validates :name, :file, presence: true

  belongs_to :employee
end
