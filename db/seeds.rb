ActiveRecord::Base.connection.execute <<-SQL
  INSERT INTO tenants (name, subdomain, tenant_id, created_at, updated_at)
  VALUES ('Main Tenant', 'main', NULL, NOW(), NOW());
SQL

root_tenant = Tenant.find_by(subdomain: "main")

academia = Tenant.create!(name: "Academia Margarita", subdomain: "academia-margarita", tenant: root_tenant)
deportivo = Tenant.create!(name: "Deportivo Margarita", subdomain: "deportivo-margarita", tenant: root_tenant)

 User.create!( email: "admin@academy1.com", password: "s3cret.", first_name: "Academy1", last_name: "Admin", role: :admin, tenant: academia)
 User.create!( email: "admin@academy2.com", password: "s3cret.", first_name: "Academy2", last_name: "Admin", role: :admin, tenant: deportivo)

# academia = Tenant.find_by(subdomain: "academia-margarita")
# ActsAsTenant.with_tenant(Tenant.find_by(subdomain: "academia-margarita")) do
#   Player.create(email: "nachitoolivo@gmail.com", tenant: academia)
# end

# deportivo = Tenant.find_by(subdomain: "deportivo-margarita")
# ActsAsTenant.with_tenant(Tenant.find_by(subdomain: "deportivo-margarita")) do
#   Player.create(email: "nuevo-ingreso@gmail.com", tenant: deportivo)
# end