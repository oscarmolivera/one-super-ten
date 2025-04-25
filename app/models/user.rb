class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  rolify

  belongs_to :tenant
  acts_as_tenant(:tenant)

  def can_view_schedules?
    is_role_tenant_admin?
  end

  def can_manage_appointments?
    staff_assistant?
  end

  def super_admin?
    has_role?(:super_admin)
  end

  def is_role_tenant_admin?
    has_role?(:tenant_admin, ActsAsTenant.current_tenant)  
  end

  def role_name
    roles.first&.name.to_s.downcase
  end

  def add_role_with_tenant(role_name, resource = nil)
    roles.create(name: role_name, resource: resource, tenant: self.tenant)
  end

  def has_role?(role_name, resource = nil)
    if resource
      super(role_name, resource)
    else
      roles.exists?(name: role_name, tenant: ActsAsTenant.current_tenant)
    end
  end
  

  def self.find_for_database_authentication(warden_conditions)
    where(email: warden_conditions[:email], tenant: ActsAsTenant.current_tenant).first
  end
end
