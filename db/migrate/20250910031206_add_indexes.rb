class AddIndexes < ActiveRecord::Migration[8.0]
  def change
    unless index_exists?(:matches, [:tenant_id, :stage_id])
      add_index :matches, [:tenant_id, :stage_id]
    end
    unless index_exists?(:matches, [:tenant_id, :stage_id, :status])
      add_index :matches, [:tenant_id, :stage_id, :status]
    end
    unless index_exists?(:roles, [:name, :resource_type, :resource_id])
      add_index :roles, [:name, :resource_type, :resource_id]
    end
    unless index_exists?(:users_roles, [:user_id, :role_id])
      add_index :users_roles, [:user_id, :role_id]
    end
  end
end