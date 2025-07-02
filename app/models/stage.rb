class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :matches, dependent: :destroy

  enum :stage_type, { group_stage: 0, knockout: 1 }

  validates :name, presence: true
  validates :stage_type, presence: true
  validates :order, presence: true
end