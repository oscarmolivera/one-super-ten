class EventPolicy < ApplicationPolicy
  def index?
  %i[tenant_admin staff_assistant coach player team_assistant]
    .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end

  def update?
    create?
  end

  def destroy?
    user.has_role?(:tenant_admin, user.tenant)
  end

  def show?
    record.is_public? || create?
  end

  class Scope < Scope
    def resolve
      scope.where(tenant: user.tenant)
    end
  end
end