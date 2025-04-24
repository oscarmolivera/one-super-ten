class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true, optional: true
  belongs_to :tenant, optional: true, inverse_of: :roles
  

  validates :resource_type, inclusion: { in: ['Tenant'] }, allow_nil: true
  validates :name, presence: true

  scopify
end
