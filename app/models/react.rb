class React < ApplicationRecord
  belongs_to :timeline
  belongs_to :reactor, polymorphic: true
end
