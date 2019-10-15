class Notification < ApplicationRecord
  include ActionView::Helpers::DateHelper
  enum read_status: %i[unread read]
  after_commit -> { Notification::NotificationWorker.perform_async(self.id) }, on: :create

  validates :content, presence: true

  belongs_to :recipient, polymorphic: true

  default_scope { order(created_at: :desc) }

  def as_json(options)
    super(options).merge(created_since: time_ago_in_words(created_at))
  end
end
