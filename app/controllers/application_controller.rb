class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :switch_tenant

  def switch_tenant
    return unless request.subdomain.present? && request.subdomain != 'www' && request.subdomain != 'admin'

    tenant = Tenant.find_by(subdomain: request.subdomain)
    
    if tenant
      set_current_tenant(tenant)  # Sets the current tenant for all queries
    else
      render file: Rails.root.join('public/404.html'), status: :not_found
    end
  end
end
