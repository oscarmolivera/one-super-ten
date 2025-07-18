class TournamentPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope, :cup

    def initialize(user, scope)
      @user = user
      @scope = scope
      @cup = scope.is_a?(ActiveRecord::Relation) ? nil : scope # fallback if needed
    end

    def resolve
      if user.has_role?(:player, ActsAsTenant.current_tenant)
        Tournament
          .for_player(user.player)
          .where(cup_id: cup_id)
          .order(start_date: :desc)
      else
        scope.where(tenant: ActsAsTenant.current_tenant)
      end
    end

    def inscribe?
      user.has_role?(:tenant_admin, user.tenant) ||
      user.has_role?(:coach, user.tenant) && user.categories.exists?(id: record.categories) ||
      user.has_role?(:assistant_coach, user.tenant) && user.categories.exists?(id: record.categories) ||
      user.has_role?(:team_assistant, user.tenant) && user.categories.exists?(id: record.categories)
    end

    private

    def cup_id
      if scope.respond_to?(:proxy_association) && scope.proxy_association&.owner.is_a?(Cup)
        scope.proxy_association.owner.id
      else
        nil
      end
    end
  end

  def index?
    %i[tenant_admin staff_assistant coach player team_assistant]
      .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end
end