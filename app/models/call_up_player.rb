class CallUpPlayer < ApplicationRecord
  belongs_to :call_up
  belongs_to :player, optional: true
  belongs_to :external_player, optional: true 

  has_many :line_ups, dependent: :destroy

  enum :attendance, { unknown: 0, present: 1, absent: 2 }

  validates :attendance, inclusion: { in: attendances.keys }
  validate :only_one_reference

  def only_one_reference
    if player_id.present? && external_player_id.present?
      errors.add(:base, "Only one of player_id or external_player_id can be present")
    elsif player_id.blank? && external_player_id.blank?
      errors.add(:base, "Must specify either player_id or external_player_id")
    end
  end
end
