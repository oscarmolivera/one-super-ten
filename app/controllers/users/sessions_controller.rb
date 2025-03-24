class Users::SessionsController < Devise::SessionsController
  before_action :set_tenant
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def create
    tenant = Tenant.find_by(subdomain: request.subdomain)
    if tenant.nil?
      flash[:alert] = "Invalid subdomain."
      redirect_to new_user_session_path and return
    end

    ActsAsTenant.current_tenant = tenant
    Rails.logger.info "Session before sign in: #{session.inspect}"
    super do |user|
      if user.present?
        ActsAsTenant.current_tenant = user.tenant
      end
    end
    Rails.logger.info "Session after sign in: #{session.inspect}"
  end

  def after_sign_in_path_for(user)
    ActsAsTenant.current_tenant = user.tenant
    stored_location_for(user) || tenant_root_path
  end

  private

  def set_tenant
    if request.subdomain.present?
      tenant = Tenant.find_by(subdomain: request.subdomain)
      if tenant
        ActsAsTenant.current_tenant = tenant
      else
        flash[:alert] = "Invalid subdomain."
        redirect_to new_user_session_path
      end
    end
  end
end