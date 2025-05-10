class TournamentCategory < ApplicationRecord
  belongs_to :tournament
  belongs_to :category

  validates :category_id, uniqueness: { scope: :tournament_id }
end
