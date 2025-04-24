class RenameTenantIdToParentTenantId < ActiveRecord::Migration[8.0]
  def change
    rename_column :tenants, :tenant_id, :parent_tenant_id
  end
end