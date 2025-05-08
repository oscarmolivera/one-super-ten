class MatchReport < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :match
  belongs_to :user

  enum :author_role, { referee: "referee", coach: "coach", delegate: "delegate" }

  validates :author_role, presence: true
  validates :general_observations, length: { maximum: 2000 }
  validates :reported_at, presence: true
  encrypts :general_observations, :incidents, :team_claims, :final_notes
end