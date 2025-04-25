class DashboardPolicy < ApplicationPolicy
  ALLOWED_ROLES = %w[coach staff_assistant tenant_admin].freeze

  def show?
    # p " ........................XXXXXXXXXXXXXXXXXXXXXXXX............................"
    # user.tenant.present? && ALLOWED_ROLES.include?(user.role_name)
    true
  end
end