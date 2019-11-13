class Comment < ApplicationRecord
  include ActionView::Helpers::DateHelper
  mount_uploader :image, ImageUploader

  validates :content, presence: true

  belongs_to :timeline
  belongs_to :commenter, polymorphic: true

  default_scope { order(created_at: :asc) }

  def as_json(options)
    super(options).merge(owner_name: commenter.name,
                         owner_id: commenter.id,
                         image: image,
                         created_since: time_ago_in_words(created_at))
  end

  def pic
    return image.url unless image.empty?
    'images/fallback/small_400_default.png'
  end
end
