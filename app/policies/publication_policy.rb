class PublicationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(tenant: user.tenant)
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    user.has_role?(:coach) || user.has_role?(:tenant_admin)
  end

  def edit?
    update?
  end

  def update?
    user.has_role?(:tenant_admin) || (user.has_role?(:coach) && record.author == user)
  end

  def destroy?
    update?
  end
end