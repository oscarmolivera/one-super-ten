class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  rolify

  belongs_to :tenant
  acts_as_tenant(:tenant)

  def super_admin?
    has_role?(:super_admin)
  end

  def add_role_with_tenant(role_name, resource = nil)
    roles.create(name: role_name, resource: resource, tenant: self.tenant)
  end

  def has_role?(role_name, resource = nil)
    Rails.logger.info "Checking role: #{role_name}, tenant: #{ActsAsTenant.current_tenant&.id}, user roles: #{roles.pluck(:name, :tenant_id)}"
    if resource
      super(role_name, resource)
    else
      roles.exists?(name: role_name, tenant: ActsAsTenant.current_tenant)
    end
  end
  

  def self.find_for_database_authentication(warden_conditions)
    where(email: warden_conditions[:email], tenant_id: ActsAsTenant.current_tenant&.id).first
  end
end
