class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(tenant: ActsAsTenant.current_tenant) 
    end
  end

  def index?
    user.has_role?(:tenant_admin, ActsAsTenant.current_tenant) && user.tenant == ActsAsTenant.current_tenant
  end

  def show?
    user.has_role?(:tenant_admin, ActsAsTenant.current_tenant) && user.tenant == ActsAsTenant.current_tenant
  end

  def update?
    user.has_role?(:tenant_admin, ActsAsTenant.current_tenant) && user.tenant == ActsAsTenant.current_tenant
  end

  def destroy?
    user.has_role?(:tenant_admin, ActsAsTenant.current_tenant) && user.tenant == ActsAsTenant.current_tenant
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def edit?
    index?
  end
end
