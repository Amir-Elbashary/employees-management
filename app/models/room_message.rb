class RoomMessage < ApplicationRecord
  validates :message, presence: true

  belongs_to :employee
  belongs_to :room
end
