class Cup < ApplicationRecord
  acts_as_tenant(:tenant)
  belongs_to :school
  has_many :tournaments, dependent: :nullify
  has_one_attached :logo
  validates :name, presence: true
end