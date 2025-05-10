class Publication < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :author, class_name: "User"
  belongs_to :category, optional: true

  has_many :publication_targets, dependent: :destroy
  has_many :target_users, through: :publication_targets, source: :user

  enum :visibility, {
    academy: "academy",
    players: "players",
    coaches: "coaches",
    custom: "custom"
  }

  validates :title, :body, :visibility, presence: true

  encrypts :title, :body
end