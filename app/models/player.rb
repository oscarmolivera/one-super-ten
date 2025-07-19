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
  validates :handle,
            uniqueness: { scope: :tenant_id },
            format: { with: /\A[a-z0-9\-_]+\z/i, message: "solo puede contener letras, números, guiones y guiones bajos" },
            allow_blank: true # Only required if profile is public

  validate :limit_carousel_images_count
  validate :permited_date_of_birth_for_players

  after_create :assign_category_based_on_birth_year

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
    position.present? ? position.capitalize : "Por Definir"
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

  def last_tournament_jersey
    SeasonTeamPlayer
      .where(player_id: id)
      .order(updated_at: :desc)
      .limit(1)
      .pick(:jersey_number) || "N/A"
  end

  def hero_image_url
    if hero_image&.attached?
      Rails.application.routes.url_helpers.rails_blob_url(self.hero_image, only_path: true)
    else
      ActionController::Base.helpers.asset_path('profile-placeholder.webp')
    end
  end

  def teammates_number
    categories.first.category_players.count
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
    dominant_side.present? ? dominant_side.capitalize :  "Sin lado preferido"
  end

  def public_handler
    handle.present? ? handle : "nombre-publico"
  end

  private

  def limit_carousel_images_count
    if carousel_images.attachments.count > 4
      errors.add(:carousel_images, "Solo puedes tener hasta 4 imágenes.")
    end
  end

  def assign_category_based_on_birth_year
    Players::AssignCategory.new(self).call
  end

  def permited_date_of_birth_for_players
    return if date_of_birth.blank?

    current_year = Date.today.year
    min_year = current_year - 17  # max age for players
    max_year = current_year - 5   # min age for players

    if date_of_birth.year < min_year || date_of_birth.year > max_year
      errors.add(:date_of_birth, "No hay una categoría disponible para esta fecha de nacimiento")
    end
  end
end