class Tenant < ApplicationRecord
  acts_as_tenant :tenant
  belongs_to :tenant

  before_validation :set_default_parent, on: :create

  private

  def set_default_parent
    self.tenant ||= Tenant.find_by(subdomain: "main")
  end
end