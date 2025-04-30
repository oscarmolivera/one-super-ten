class School < ApplicationRecord
  acts_as_tenant(:tenant)
  belongs_to :tenant

  has_many :categories, dependent: :destroy
  has_many :player_schools, dependent: :destroy
  has_many :players, through: :player_schools

  validates :name, presence: true
end