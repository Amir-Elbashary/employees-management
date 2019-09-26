class Timeline < ApplicationRecord
  include ActionView::Helpers::DateHelper
  mount_uploaders :images, ImageUploader
  enum kind: %i[news status show_off]
  enum creation: %i[manual auto]
  after_commit -> { Timeline::TimelineWorker.perform_async(self.id) }, on: :create

  validates :content, presence: true

  belongs_to :admin, optional: true
  belongs_to :hr, optional: true
  belongs_to :employee, optional: true

  default_scope { order(created_at: :desc) }

  def as_json(options)
    super(options).merge(avatar_url: avatar_url,
                         owner_name: owner.full_name,
                         owner_id: owner.id,
                         image: image,
                         created_since: time_ago_in_words(created_at))
  end

  def owner
    return admin if admin
    return hr if hr
    return employee if employee
  end

  def avatar_url
    return owner.avatar_url if owner.avatar.present?
    'images/fallback/small_400_default.png'
  end

  def image
    return images.first.url unless images.empty?
    'images/fallback/small_400_default.png'
  end
end
