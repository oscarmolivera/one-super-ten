class Category < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :school
  belongs_to :tenant
  
  has_many :category_players, dependent: :destroy
  has_many :players, through: :category_players

  has_many :category_coaches
  has_many :coaches, through: :category_coaches, source: :user
  
  has_many :category_team_assistants
  has_many :team_assistants, through: :category_team_assistants, source: :user

  has_many :call_ups, dependent: :destroy
  has_many :matches, -> { distinct }, through: :call_ups

  def sub_name
    category_year = Date.today.year - slug.gsub('sub_','').to_i  + 1
    "#{name}(#{category_year})"
  end
end