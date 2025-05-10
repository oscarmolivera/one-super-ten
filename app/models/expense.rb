class Expense < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :author, class_name: "User"
  belongs_to :expensable, polymorphic: true, optional: true

  enum :expense_type, {
    salary:       "salary",
    service:      "service",
    tax:          "tax",
    event:        "event",
    maintenance:  "maintenance",
    other:        "other"
  }

  validates :title, :amount, :spent_on, :expense_type, presence: true
  validates :amount, numericality: { greater_than: 0 }

  scope :recent, -> { order(spent_on: :desc) }
  encrypts :title, :description, :reference_code, :payment_method
end