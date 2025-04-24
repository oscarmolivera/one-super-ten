ActiveRecord::Base.connection.execute <<-SQL
  INSERT INTO tenants (name, subdomain, created_at, updated_at, parent_tenant_id)
  VALUES ('Main Tenant', 'main', '#{Time.current}', '#{Time.current}', NULL),
  ('Academia Margarita', 'academia-margarita', '#{Time.current}', '#{Time.current}', 1),
  ('Deportivo Margarita', 'deportivo-margarita', '#{Time.current}', '#{Time.current}', 1);
SQL

root_tenant = Tenant.find_by(subdomain: "main")
academia = Tenant.find_by(subdomain: "academia-margarita")
deportivo = Tenant.find_by(subdomain: "deportivo-margarita")

su = User.create!(email: "admin@nubbe.net", password: "s3cret.", first_name: "Super Admin", last_name: "Nubbe.Net", tenant: root_tenant)
ta_aca =User.create!(email: "admin@academy1.com", password: "s3cret.", first_name: "Academy1", last_name: "Admin", tenant: academia)
ta_dep = User.create!(email: "admin@academy2.com", password: "s3cret.", first_name: "Academy2", last_name: "Admin", tenant: deportivo)



# SuperAdmin for Tenants  
Role.find_or_create_by(name: :super_admin, resource: root_tenant, tenant: su.tenant)

# TenantAdmin for Academies
Role.find_or_create_by(name: :tenant_admin, resource: academia, tenant: ta_aca.tenant)
Role.find_or_create_by(name: :tenant_admin, resource: deportivo, tenant: ta_dep.tenant)

# Role Assignments
su.add_role(:super_admin, root_tenant)
ta_aca.add_role(:tenant_admin, academia)
ta_dep.add_role(:tenant_admin, deportivo)

# Base Roles for Tenants
# [ 
#   :tenant_admin,
#   :staft_admin,
#   :coach,
#   :team_assistant,
#   :player,
#   :parent,
#   :guest
# ].each do |role|
#   Role.find_or_create_by(name: role, resource: academia,  tenant: root_tenant)
# end



# academia = Tenant.find_by(subdomain: "academia-margarita")
# ActsAsTenant.with_tenant(Tenant.find_by(subdomain: "academia-margarita")) do
#   Player.create(email: "nachitoolivo@gmail.com", tenant: academia)
# end

# deportivo = Tenant.find_by(subdomain: "deportivo-margarita")
# ActsAsTenant.with_tenant(Tenant.find_by(subdomain: "deportivo-margarita")) do
#   Player.create(email: "nuevo-ingreso@gmail.com", tenant: deportivo)
# end