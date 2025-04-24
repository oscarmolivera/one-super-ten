class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(tenant_id: ActsAsTenant.current_tenant&.id) 
    end
  end

  def index?
    user.has_role?(:tenant_admin) && user.tenant_id == ActsAsTenant.current_tenant&.id
  end

  def show?
    user.has_role?(:tenant_admin) && record.tenant_id == user.tenant_id
  end

  def update?
    user.has_role?(:tenant_admin) && record.tenant_id == user.tenant_id
  end

  def destroy?
    user.has_role?(:tenant_admin) && record.tenant_id == user.tenant_id
  end
end
