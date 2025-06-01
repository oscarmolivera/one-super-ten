class PlayerPolicy < ApplicationPolicy
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

  def edit?
    return true if user == record.user 
    
    false
  end

def public_show?
  record.public_profile? # Only allow access if marked public
end

  def destroy?
    index?
  end
end