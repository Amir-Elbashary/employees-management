class RoomMessage < ApplicationRecord
  validates :message, presence: true

  belongs_to :employee
  belongs_to :room

  def as_json(options)
    super(options).merge(avatar_url: employee.avatar_url,
                         sender_name: employee.full_name,
                         sender_id: employee.id)
  end

  def created_at
    attributes['created_at'].strftime("%I:%M %p")
  end

  default_scope { order(created_at: :asc) }
end
