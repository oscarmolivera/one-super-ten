class Tenant < ApplicationRecord
  belongs_to :parent_tenant, class_name: 'Tenant', optional: true
  has_many :subtenants, class_name: 'Tenant', foreign_key: 'parent_tenant_id'
  has_many :roles, inverse_of: :tenant

  before_validation :set_default_parent, on: :create

  validates :subdomain, presence: true, uniqueness: true

  private

  def set_default_parent
    self.parent_tenant ||= Tenant.find_by(subdomain: 'main')
  end
end