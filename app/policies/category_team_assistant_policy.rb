class CategoryTeamAssistantPolicy < ApplicationPolicy
  def create?
    %i[tenant_admin staff_assistant coach player team_assistant]
      .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end
end