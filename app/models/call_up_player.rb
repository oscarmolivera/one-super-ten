class CallUpPlayer < ApplicationRecord
  belongs_to :call_up
  belongs_to :player

  enum :attendance, { unknown: 0, present: 1, absent: 2 }

  validates :attendance, inclusion: { in: attendances.keys }
end