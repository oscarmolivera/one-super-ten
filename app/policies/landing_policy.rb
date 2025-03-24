class LandingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(tenant_id: ActsAsTenant.current_tenant&.id) # 🔹 Only fetch landings for the current tenant
    end
  end

  def show?
    record.tenant_id == user.tenant_id
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? && record.tenant_id == user.tenant_id
  end

  def destroy?
    user.admin? && record.tenant_id == user.tenant_id
  end
end