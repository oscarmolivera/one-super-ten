class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :switch_tenant

  def switch_tenant
    return unless request.subdomain.present? && request.subdomain != 'www' && request.subdomain != 'admin'

    begin
      tenant = Tenant.find_by(subdomain: request.subdomain)

      if tenant
        ActsAsTenant.current_tenant = tenant
      else
        render file: Rails.root.join('public/404.html'), status: :not_found
      end
    rescue ActiveRecord::ActiveRecordError => e
      Rails.logger.error("Tenant lookup failed: #{e.message}")
      render file: Rails.root.join('public/500.html'), status: :internal_server_error
    end
  end
end
