class ProductSale < ApplicationRecord
  has_one :income, as: :source
end