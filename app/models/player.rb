class Player < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :user, optional: true

  has_many :player_schools, dependent: :destroy
  has_many :schools, through: :player_schools

  has_many :category_players, dependent: :destroy
  has_many :categories, through: :category_players
  has_many :exonerations, dependent: :destroy

  validates :first_name, :last_name, presence: true

  enum :gender, { hombre: 'hombre', mujer: 'mujer' }
  enum :dominant_side, {izquierdo: 'izquierdo', derecho: 'derecho', ambos: 'ambos'}
  enum :position, {portero: 'portero', mediocampo: 'mediocampo', lateral: 'lateral', defensa: 'defensa', delantero: 'delantero'  }



  def full_name
    "#{first_name} #{last_name}"
  end
    
  def exonerated_for?(date = Date.today)
    exonerations.any? { |e| e.active?(date) }
  end
end