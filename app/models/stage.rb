class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :matches, dependent: :destroy

  enum :stage_type, { group_stage: 0, knockout: 1 }
  enum :phase, { 
    primera_ronda: 0, 
    segunda_ronda: 1,
    octavos: 2,
    cuartos: 3,
    semifinales: 4,
    tercer_puesto: 5,
    final: 6
  }

  validates :name, presence: true
  validates :stage_type, presence: true
  validates :order, presence: true
  validates :phase, presence: true
end