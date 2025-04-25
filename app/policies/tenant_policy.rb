class TenantPolicy < ApplicationPolicy
  def view_citas?
    user.has_role?(:tenant_admin, record) || user.has_role?(:staff_assistant, record)
  end

  def manage_schedules?
    user.has_role?(:tenant_admin, record) || user.has_role?(:coach, record)
  end

  def manage_schedules?
    user.has_role?(:tenant_admin, record) || user.has_role?(:coach, record)
  end
end
