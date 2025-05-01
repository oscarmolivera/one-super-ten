class Category < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :school
  belongs_to :tenant
  
  has_many :category_players, dependent: :destroy
  has_many :players, through: :category_players

  has_many :category_coaches
  has_many :coaches, through: :category_coaches, source: :user
end