class CallUp < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :category
  belongs_to :match, optional: true
  
  has_many :call_up_players, dependent: :destroy
  has_many :players, through: :call_up_players

  enum :status, { draft: 0, finalized: 1, notified: 2, completed: 3 }
  
  validates :name, :call_up_date, presence: true
end