class CategoryRule < ApplicationRecord
  belongs_to :category

  validates :key, presence: true
  validates :value, presence: true
  validates :key, uniqueness: { scope: :category_id }

  # Example: scope to find rules by key
  scope :with_key, ->(key) { where(key: key) }
end