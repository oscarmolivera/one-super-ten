class Event < ApplicationRecord
  acts_as_tenant :tenant

  belongs_to :school, optional: true
  belongs_to :tenant
  belongs_to :coach, class_name: "User", optional: true

  has_many :event_participations, dependent: :destroy
  has_many :categories, through: :event_participations

  has_many :reinforcements, dependent: :destroy

  enum :event_type, { match: 0, friendly: 1, tournament: 2 }
  enum :status, { draft: 0, published: 1, canceled: 2 }

  validates :title, :start_time, presence: true

  def internal?
    !external_organizer && school.present?
  end

  def external?
    external_organizer && organizer_name.present?
  end
end