class TrainingAttendance < ApplicationRecord
  belongs_to :training_session
  belongs_to :player

  validates :status, inclusion: { in: %w[present absent late excused] }
end