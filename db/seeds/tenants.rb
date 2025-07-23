ActiveRecord::Base.connection.execute <<-SQL
  INSERT INTO tenants (name, subdomain, created_at, updated_at, parent_tenant_id)
  VALUES ('Main Tenant', 'main', '#{Time.current}', '#{Time.current}', NULL),
  ('Academia Margarita', 'academia-margarita', '#{Time.current}', '#{Time.current}', 1),
  ('Deportivo Margarita', 'deportivo-margarita', '#{Time.current}', '#{Time.current}', 1);
SQL