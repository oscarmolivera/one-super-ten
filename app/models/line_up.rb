class LineUp < ApplicationRecord
  belongs_to :match, touch: true
  belongs_to :call_up_player, touch: true

  delegate :player, to: :call_up_player

  enum :role, { starter: 0, bench: 1 }

  validates :position, presence: true
end