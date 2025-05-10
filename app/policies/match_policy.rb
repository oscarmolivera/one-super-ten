class MatchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope  # Or apply more specific filtering here if needed
    end
  end

  def index?
    %i[tenant_admin staff_assistant coach player team_assistant]
      .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end

  def create?
    user.has_role?(:team_assistant) && user.assigned_categories.include?(record.category)
  end

  def update?
    create?
  end
end
