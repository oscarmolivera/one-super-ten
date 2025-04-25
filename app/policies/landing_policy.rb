class LandingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(tenant: ActsAsTenant.current_tenant)
    end
  end

  def show?
    record.tenant == user.tenant
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? && record.tenant == user.tenant
  end

  def destroy?
    user.admin? && record.tenant == user.tenant
  end
end