class Player < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :user, optional: true

  has_many :player_schools, dependent: :destroy
  has_many :schools, through: :player_schools

  has_many :category_players, dependent: :destroy
  has_many :categories, through: :category_players
  has_many :exonerations, dependent: :destroy
  has_many :match_performances, dependent: :destroy
  has_one :player_profile, dependent: :destroy
  
  accepts_nested_attributes_for :player_profile, update_only: true
  has_one_attached :profile_picture, dependent: :destroy
  has_many_attached :documents, dependent: :destroy

  validates :first_name, :last_name, presence: true

  enum :gender, { hombre: 'hombre', mujer: 'mujer' }
  enum :dominant_side, {izquierdo: 'izquierdo', derecho: 'derecho', ambos: 'ambos'}
  enum :nationality, {venezolano: 'venezolano', extranjero: 'extranjero', nacionalizado: 'nacionalizado'}
  enum :position, {portero: 'portero', mediocampo: 'mediocampo', lateral: 'lateral', defensa: 'defensa', delantero: 'delantero', por_definir: 'por_definir'  }

  encrypts :first_name, :last_name, :email, :nationality, :document_number, :address, :bio, :notes


  def full_name
    "#{first_name} #{last_name}"
  end

  def public_full_name
    if player_profile&.nickname.present?
      "#{first_name} “#{player_profile.nickname}” #{last_name}"
    else
      full_name
    end
  end

  def age
    return nil if date_of_birth.blank?

    today = Date.today
    age = today.year - date_of_birth.year
    age -= 1 if today.month < date_of_birth.month || (today.month == date_of_birth.month && today.day < date_of_birth.day)
    age
  end
    
  def exonerated_for?(date = Date.today)
    exonerations.any? { |e| e.active?(date) }
  end
end