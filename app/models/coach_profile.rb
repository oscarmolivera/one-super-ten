class CoachProfile < ApplicationRecord
  belongs_to :user

  validates :hire_date, :salary, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :recent_hires, -> { where('hire_date > ?', 6.months.ago) }
  scope :high_salary, ->(amount = 5000) { where('salary >= ?', amount) }

end