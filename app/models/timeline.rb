class Timeline < ApplicationRecord
  include ActionView::Helpers::DateHelper
  mount_uploaders :images, ImageUploader
  enum kind: %i[news status show_off]
  enum creation: %i[manual auto]
  after_commit -> { Timeline::TimelineWorker.perform_async(self.id) }, on: :create

  validates :content, presence: true

  has_many :reacts, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :publisher, polymorphic: true

  default_scope { order(created_at: :desc) }

  def as_json(options)
    super(options).merge(avatar_url: avatar_url,
                         owner_name: publisher.name,
                         owner_id: publisher.id,
                         image: image,
                         created_since: time_ago_in_words(created_at))
  end

  def avatar_url
    return publisher.avatar_url if publisher.avatar.present?
    'images/fallback/small_400_default.png'
  end

  def image
    return images.first.url unless images.empty?
    'images/fallback/small_400_default.png'
  end
end
