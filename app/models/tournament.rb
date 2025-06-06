class Tournament < ApplicationRecord
  belongs_to :tenant
  belongs_to :cup, optional: true
  
  has_many :inscriptions
  has_many :categories, through: :inscriptions
  
  has_many :tournament_categories, dependent: :destroy
  has_many :categories, through: :tournament_categories
  
  has_many :matches, dependent: :destroy
  has_many :sites, through: :matches # Assuming matches happen at sites

  has_rich_text :rules # For formatted rules text
  has_one_attached :poster # Optional image or PDF

  delegate :school, to: :cup, allow_nil: true

  enum :status, { draft: 0, published: 1, ongoing: 2, completed: 3 }

  validates :name, :start_date, :end_date, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }

  scope :publicly_visible, -> { where(public: true) }
  scope :ongoing, -> { where(status: 'ongoing') }

  scope :for_player, ->(player) {
    joins(:categories)
      .where(categories: { id: player.category_ids })
      .where(tenant: player.tenant)
      .where(public: true)
      .distinct
  }

  scope :inscribed_by_player, ->(player) {
    joins(:inscriptions).where(inscriptions: { category_id: player.category_ids })
  }

    def selected_category_count
      categories.distinct.count
    end

    def season_team_category_count
      inscriptions.where.not(season_team_id: nil).select(:category_id).distinct.count
    end
end