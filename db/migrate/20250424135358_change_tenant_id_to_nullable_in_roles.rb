class ChangeTenantIdToNullableInRoles < ActiveRecord::Migration[7.0]
  def change
    change_column_null :roles, :tenant_id, true
  end
end