class Income < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :source, polymorphic: true, optional: true

  enum :income_type, {
    monthly_payment: "monthly_payment",
    product_sale: "product_sale",
    sponsor: "sponsor",
    investment: "investment",
    other: "other"
  }

  validates :title, :amount, :income_type, :received_at, presence: true
  encrypts :title, :description, :tag
end