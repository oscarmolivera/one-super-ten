class InscriptionPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope # This will now be a relation like tournament.categories
    end

    def resolve
      if user.has_role?(:tenant_admin, user.tenant)
        scope
      elsif user.has_role?(:coach, user.tenant) || user.has_role?(:assistant_coach, user.tenant)
        scope.where(id: user.categories.select(:id))
      elsif user.has_role?(:team_assistant, user.tenant)
        scope.where(id: user.category_id)
      else
        scope.none
      end
    end
  end

  def create?
    return true if user.has_role?(:tenant_admin, user.tenant)
    return true if user.has_role?(:coach, user.tenant) && user.categories.include?(record.category)
    return true if user.has_role?(:assistant_coach, user.tenant) && user.categories.include?(record.category)
    return true if user.has_role?(:team_assistant, user.tenant) && user.category == record.category
    false
  end
end