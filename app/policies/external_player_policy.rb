class ExternalPlayerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where.not(id: nil)
    end
  end
  
  def index?
    %i[tenant_admin staff_assistant coach player team_assistant]
      .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end
end