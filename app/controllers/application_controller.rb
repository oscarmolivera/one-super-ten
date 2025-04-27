class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :switch_tenant
  before_action :authorize_super_admin, if: -> { request.subdomain == "admin" }
  
  before_action :ensure_tenant_user, if: -> { current_user.present? }

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  

  def switch_tenant
    subdomain = fetch_subdomain
    return if subdomain.blank?

    tenant = Tenant.find_by(subdomain: subdomain)

    if tenant
      ActsAsTenant.current_tenant = tenant
    else
      redirect_to default_redirect_url, allow_other_host: true, alert: 'Invalid tenant'
    end
  end

  def authorize_super_admin
    redirect_to main_root_path, alert: "Access Denied" unless current_user&.super_admin?
  end

  private

  def ensure_tenant_user
    if current_user && ActsAsTenant.current_tenant
      if current_user.tenant_id != ActsAsTenant.current_tenant.id
        sign_out current_user
        redirect_to new_user_session_path, alert: "Unauthorized access to tenant."
      else
      end
    else
      sign_out current_user
      redirect_to new_user_session_path, alert: "Session invalid. Please log in again."
    end
  end
  
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || main_root_path)
  end

  def default_redirect_url
    return root_url if Rails.env.development?
    
    "https://#{ENV.fetch('APP_DOMAIN')}"
  end

  def fetch_subdomain
    host = request.host
    app_domain = Rails.env.development? ? 'localhost.me' : ENV.fetch('APP_DOMAIN')

    if host == app_domain || host == "www.#{app_domain}"
      nil
    else
      parts = host.split('.')
      parts.first
    end
  end
end