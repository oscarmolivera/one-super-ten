class CategoryPlayer < ApplicationRecord
  belongs_to :category
  belongs_to :player

  validates :player_id, uniqueness: { scope: :category_id }
end