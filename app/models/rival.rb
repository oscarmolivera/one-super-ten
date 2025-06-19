class Rival < ApplicationRecord
  belongs_to :tenant, optional: true

  has_one_attached :team_logo, dependent: :destroy

  has_many :season_team_rivals, dependent: :destroy
  has_many :season_teams, through: :season_team_rivals

  validates :name, presence: true, length: { maximum: 120 }

  scope :common,  -> { where(tenant_id: nil) }
  scope :for_tenant, ->(tenant) { where(tenant_id: tenant.id).or(common) }
end