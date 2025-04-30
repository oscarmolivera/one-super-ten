class CategoryPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(tenant: ActsAsTenant.current_tenant)
    end
  end

  def index?
    %i[tenant_admin staff_assistant coach player team_assistant]
      .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end

  def show?
    index?
  end

  def destroy?
    index?
  end
end
