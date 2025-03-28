class ApplicationController < ActionController::Base
  include Pundit::Authorization
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :switch_tenant
  before_action :authorize_super_admin, if: -> { request.subdomain == "admin" }
  
  before_action :force_session_initialization
  before_action :ensure_tenant_user, if: -> { current_user.present? }
  # before_action :debug_session

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  

  def switch_tenant
    subdomain = fetch_subdomain

    return if subdomain.blank? || %w[www landing].include?(subdomain)
    
    tenant = Tenant.find_by(subdomain: fetch_subdomain)
    
    if tenant
      ActsAsTenant.current_tenant = tenant
    else
      redirect_to new_user_session_path, alert: 'Invalid tenant'
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
    redirect_to(request.referer || root_path)
  end

  def fetch_subdomain
    full_host = request.host
    parts = full_host.split('.')
    parts.first unless parts.first == 'localhost'
  end
end