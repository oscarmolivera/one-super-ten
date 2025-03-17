class AddTenantToTenants < ActiveRecord::Migration[8.0]
  def change
    add_reference :tenants, :tenant, null: true, foreign_key: { to_table: :tenants }
  end
end
