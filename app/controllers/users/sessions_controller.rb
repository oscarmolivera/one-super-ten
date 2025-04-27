class Users::SessionsController < Devise::SessionsController
  before_action :set_tenant
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def create
    unless ActsAsTenant.current_tenant
      flash[:alert] = "Invalid subdomain."
      redirect_to new_user_session_path and return
    end

    super do |user|
      if user.present?
        if user.tenant.id != ActsAsTenant.current_tenant.id
          sign_out user
          flash[:alert] = "Unauthorized access to tenant."
          redirect_to new_user_session_path and return
        end
      end
    end
    # Rails.logger.info "Session after sign in: #{session.inspect}"
  end

  def after_sign_in_path_for(user)
    if user.has_role?(:super_admin)
      superadmin_root_path
    elsif user.has_role?(:tenant_admin, ActsAsTenant.current_tenant) && user.tenant == ActsAsTenant.current_tenant
      tenant_dashboard_path
    else
      main_root_path
    end
  end

  private

  def set_tenant
    return if ActsAsTenant.current_tenant.present?

    tenant = Tenant.find_by(subdomain: request.subdomain)
    if tenant.present?
      ActsAsTenant.current_tenant = tenant
    else
      Rails.logger.warn "Subdomain not found: #{request.subdomain}"
      unless request.path == new_user_session_path
        flash[:alert] = "Invalid subdomain."
        redirect_to new_user_session_path
      end
    end
  end
end