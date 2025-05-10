class Site < ApplicationRecord
  belongs_to :school
  has_many :training_sessions, dependent: :nullify
  has_many :matches, dependent: :nullify
  has_many :events, dependent: :nullify # if you're using the Event entity

  validates :name, presence: true
end