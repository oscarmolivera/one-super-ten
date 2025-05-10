class CategoryPlayer < ApplicationRecord
  belongs_to :category, touch: true
  belongs_to :player, touch: true

  validates :player_id, uniqueness: { scope: :category_id }
end