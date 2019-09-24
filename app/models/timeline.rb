class Timeline < ApplicationRecord
  mount_uploaders :images, ImageUploader
  enum kind: %i[news status show_off quote]
  enum creation: %i[manual auto]

  validates :content, presence: true

  belongs_to :admin, optional: true
  belongs_to :hr, optional: true
  belongs_to :employee, optional: true

  default_scope { order(created_at: :desc) }

  def publisher
    return admin if admin
    return hr if hr
    return employee if employee
  end
end
