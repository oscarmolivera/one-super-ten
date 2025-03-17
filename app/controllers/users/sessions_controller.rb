class Users::SessionsController < Devise::SessionsController
  before_action :set_tenant

  def create
    super
  end

  private

  def set_tenant
    if request.subdomain.present?
      tenant = Tenant.find_by(subdomain: request.subdomain)
      if tenant
        set_current_tenant(tenant)
      else
        render file: Rails.root.join('public/404.html'), status: :not_found
      end
    end
  end
end