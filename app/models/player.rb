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
  has_many :guardians, dependent: :destroy
  has_one :player_profile, dependent: :destroy
  
  accepts_nested_attributes_for :player_profile
  accepts_nested_attributes_for :guardians, allow_destroy: true
  has_one_attached :profile_picture, dependent: :destroy
  has_one_attached :hero_image, dependent: :destroy
  has_many_attached :documents, dependent: :destroy
  has_many_attached :carousel_images, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validate :limit_carousel_images_count


  enum :gender, { hombre: 'hombre', mujer: 'mujer' }
  enum :dominant_side, {izquierdo: 'izquierdo', derecho: 'derecho', ambos: 'ambos'}
  enum :nationality, {venezolano: 'venezolano', extranjero: 'extranjero', nacionalizado: 'nacionalizado'}
  enum :position, {portero: 'portero', mediocampo: 'mediocampo', lateral: 'lateral', defensa: 'defensa', delantero: 'delantero', por_definir: 'por definir'  }

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

  def public_position
    if position.present?
      position.capitalize
    else
      "Por Definir"
    end
  end

  def age
    return nil if date_of_birth.blank?

    today = Date.today
    age = today.year - date_of_birth.year
    age -= 1 if today.month < date_of_birth.month || (today.month == date_of_birth.month && today.day < date_of_birth.day)
    age
  end

  def jersey_selection
    if player_profile&.jersey_number.present?
      player_profile.jersey_number
    else
      99
    end
  end

def hero_image_url
  if hero_image&.attached?
    Rails.application.routes.url_helpers.rails_blob_url(self.hero_image, only_path: true)
  else
    ActionController::Base.helpers.asset_path('profile-placeholder.webp')
  end
end

  def exonerated_for?(date = Date.today)
    exonerations.any? { |e| e.active?(date) }
  end

  def add_carousel_images(new_files)
    files_to_attach = Array(new_files).reject(&:blank?)
    return if files_to_attach.empty?

    current_count = carousel_images.count
    overflow_count = (current_count + files_to_attach.size) - 4

    if overflow_count > 0
      carousel_images.order(:created_at).limit(overflow_count).each(&:purge)
    end

    carousel_images.attach(files_to_attach)
  end

  def preferent_side
    if dominant_side.present?
      dominant_side.capitalize
    else
      "Sin lado preferido"
    end
  end

  private

  def limit_carousel_images_count
    if carousel_images.attachments.count > 4
      errors.add(:carousel_images, "Solo puedes tener hasta 4 imágenes.")
    end
  end
end