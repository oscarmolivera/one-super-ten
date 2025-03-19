class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :switch_tenant
  before_action :authorize_super_admin, if: -> { request.subdomain == "admin" }
  
  before_action :force_session_initialization
  before_action :ensure_tenant_user, if: -> { current_user.present? }
  # before_action :debug_session
  
  def switch_tenant
    subdomain = request.subdomain.presence # Ensure it's not an empty string
    return if subdomain.nil? || subdomain == "www" || subdomain == "admin"

    tenant = Tenant.find_by(subdomain: subdomain)
    
    if tenant
      ActsAsTenant.current_tenant = tenant
    else
      render file: Rails.root.join('public/404.html'), status: :not_found
    end
  end

  def authorize_super_admin
    redirect_to root_path, alert: "Access Denied" unless current_user&.super_admin?
  end

  def force_session_initialization
    session[:init] ||= SecureRandom.hex(8)
  end

  private

  def debug_session
    session[:test] ||= "Hello, SolidCache!"
    Rails.logger.debug "📌 Session ID: #{session.id.inspect}"
    Rails.logger.debug "📌 Session Data: #{session.to_hash.inspect}"
  end

  def ensure_tenant_user
    return if current_user.nil? 

    unless current_user.tenant_id == ActsAsTenant.current_tenant&.id
      sign_out current_user
      redirect_to new_user_session_path, alert: "Unauthorized access to this tenant."
    end
  end

  Warden::Manager.after_set_user do |user, warden, _options|
    if user
      ActsAsTenant.current_tenant = user.tenant
    end
  end
end