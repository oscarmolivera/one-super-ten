class ExternalPlayer < ApplicationRecord
  has_many :season_team_players, dependent: :nullify

  validates :first_name, :last_name, :position, :jersey_number, :date_of_birth, presence: true
  validates_uniqueness_of :document_number, allow_blank: true, case_sensitive: false
  
  def full_name
    "#{first_name} #{last_name}"
  end
end