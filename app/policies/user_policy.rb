class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(tenant_id: ActsAsTenant.current_tenant&.id) # 🔹 Only show users from the current tenant
    end
  end

  def index?
    user.admin? && user.tenant_id == ActsAsTenant.current_tenant&.id
  end

  def show?
    user.admin? && record.tenant_id == user.tenant_id
  end

  def update?
    user.admin? && record.tenant_id == user.tenant_id
  end

  def destroy?
    user.admin? && record.tenant_id == user.tenant_id
  end
end