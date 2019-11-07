class React < ApplicationRecord
  enum react: %i[like love joy wow sad angry]

  belongs_to :timeline
  belongs_to :reactor, polymorphic: true
end
