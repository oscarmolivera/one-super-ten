class TenantsController < ApplicationController
  before_action :require_superadmin!

  def index
    @tenants = Tenant.all
  end

  private

  def require_superadmin!
    unless current_user&.super_admin?
      redirect_to root_path, alert: "Access denied"
    end
  end
end