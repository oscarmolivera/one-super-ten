class Match < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tournament, optional: true
  has_many :call_ups, dependent: :destroy
  has_many :call_ups, dependent: :destroy
  has_many :categories, through: :call_ups

  enum :match_type, { friendly: 0, tournament: 1 }

  validates :opponent_name, :location, :scheduled_at, presence: true
end