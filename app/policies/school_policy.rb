class SchoolPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:player, ActsAsTenant.current_tenant)
        School.joins(:player_schools)
              .where(player_schools: { player_id: user.player.id, active: true })
              .distinct
      else
        scope.where(tenant: ActsAsTenant.current_tenant)
      end
    end
  end

  def index?
    %i[tenant_admin staff_assistant coach player team_assistant].any? do |role|
      user.has_role?(role, ActsAsTenant.current_tenant)
    end
  end


  def show?
    index?
  end

  def destroy?
    index?
  end
end
