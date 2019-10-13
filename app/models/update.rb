class Update < ApplicationRecord
  mount_uploaders :images, ImageUploader

  validates :version, presence: true
  validates :version, uniqueness: { case_sensitive: false }

  default_scope { order(id: :asc) }
end
