class Message < ApplicationRecord
  mount_uploaders :files, DocumentUploader
  enum read_status: %i[unread read]
  enum starring: %i[unstarred starred]
  enum trashing: %i[untrashed trashed]
  # after_commit -> { Message::MessageNotificationWorker.perform_async(self.id) }, on: :create
  after_commit -> { Message::MailNotifierWorker.perform_async(self.id) }, on: :create

  validates :subject, :content, presence: true

  belongs_to :sender, polymorphic: true
  belongs_to :recipient, polymorphic: true

  default_scope { order(created_at: :desc) }

  def as_json(options)
    super(options)[:content] = "You have new message from #{sender&.name}"
  end
end
