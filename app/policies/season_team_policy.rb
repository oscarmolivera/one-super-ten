class SeasonTeamPolicy < ApplicationPolicy
  def index?
    %i[tenant_admin staff_assistant coach player team_assistant]
      .any? { |role| user.has_role?(role, ActsAsTenant.current_tenant) }
  end

  def new?
    index?
  end

  def show?
    record.tenant == user.tenant
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    create?
  end

  def tournament_data?
    index?
  end

  def upload_regulations?
    index?
  end

  def lazy_rival_modal?
    index?
  end

  def favorite_rivals?
    index?
  end
  class Scope < Scope
    def resolve
      scope.where(tenant: user.tenant)
    end
  end
end