class TrainingSession < ApplicationRecord
  belongs_to :category
  belongs_to :coach, class_name: 'User'
  belongs_to :site, optional: true

  has_many :training_attendances, dependent: :destroy
  has_many :players, through: :training_attendances

  validates :scheduled_at, :duration_minutes, presence: true
end