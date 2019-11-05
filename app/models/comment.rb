class Comment < ApplicationRecord
  include ActionView::Helpers::DateHelper
  mount_uploader :image, ImageUploader
  # after_commit -> { Timeline::TimelineWorker.perform_async(self.id) }, on: :create

  validates :content, presence: true

  belongs_to :timeline
  belongs_to :admin, optional: true
  belongs_to :hr, optional: true
  belongs_to :employee, optional: true

  default_scope { order(created_at: :asc) }

  def as_json(options)
    super(options).merge(owner_name: owner.full_name,
                         owner_id: owner.id,
                         image: image,
                         created_since: time_ago_in_words(created_at))
  end

  def owner
    return admin if admin
    return hr if hr
    return employee if employee
  end

  def pic
    return image.url unless image.empty?
    'images/fallback/small_400_default.png'
  end
end
