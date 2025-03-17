ActiveRecord::Base.connection.execute <<-SQL
  INSERT INTO tenants (name, subdomain, tenant_id, created_at, updated_at)
  VALUES ('Main Tenant', 'main', NULL, NOW(), NOW());
SQL

root_tenant = Tenant.find_by(subdomain: "main")

Tenant.create!(name: "Academia Margarita", subdomain: "academia-margarita", tenant: root_tenant)
Tenant.create!(name: "Deportivo Margarita", subdomain: "deportivo-margarita", tenant: root_tenant)

academia = Tenant.find_by(subdomain: "academia-margarita")
ActsAsTenant.with_tenant(Tenant.find_by(subdomain: "academia-margarita")) do
  Player.create(email: "nachitoolivo@gmail.com", tenant: academia)
end

deportivo = Tenant.find_by(subdomain: "deportivo-margarita")
ActsAsTenant.with_tenant(Tenant.find_by(subdomain: "deportivo-margarita")) do
  Player.create(email: "nuevo-ingreso@gmail.com", tenant: deportivo)
end