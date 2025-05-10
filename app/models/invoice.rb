class Invoice < ApplicationRecord
  has_one :income, as: :source
end