class StagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where.not(school_id: 0)
    end
  end

  def index?
    %i[tenant_admin staff_assistant coach player team_assistant]
      .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end

  def check_closable?
    # Allow tenant_admin or other relevant roles to check if a stage is closable
    %i[tenant_admin staff_assistant coach]
      .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end
end