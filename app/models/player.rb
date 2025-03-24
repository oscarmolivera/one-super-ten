class Player < ApplicationRecord
  acts_as_tenant(:tenant)
  validates_uniqueness_of :email, scope: :tenant_id
end