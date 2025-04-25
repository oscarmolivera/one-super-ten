class DashboardPolicy < ApplicationPolicy
  ALLOWED_ROLES = %w[coach staff_assistant tenant_admin].freeze

  def show?
    user.tenant.present? && ALLOWED_ROLES.include?(user.role_name)
  end
end