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
ta_aca =User.create!(email: "admin@academia.com", password: "s3cret.", first_name: "Luis", last_name: "TenantAdmin", tenant: academia)
ta_dep = User.create!(email: "admin@deportivo.com", password: "s3cret.", first_name: "Gilberto", last_name: "TenantAdmin", tenant: deportivo)
sa_aca =User.create!(email: "administrador@academy1.com", password: "s3cret.", first_name: "Miriam", last_name: "StaffAdmin", tenant: academia)
sa_dep =User.create!(email: "administrador@academy2.com", password: "s3cret.", first_name: "Alberto", last_name: "StaffAdmin", tenant: deportivo)
co_aca =User.create!(email: "entrenador@academy1.com", password: "s3cret.", first_name: "Rodrigo", last_name: "Coach", tenant: academia)
co_dep =User.create!(email: "entrenador@academy2.com", password: "s3cret.", first_name: "Samuel", last_name: "Coach", tenant: deportivo)
ju_aca =User.create!(email: "jugador1@academy1.com", password: "s3cret.", first_name: "Julian", last_name: "Jugador", tenant: academia)
ju_dep =User.create!(email: "jugador1@academy2.com", password: "s3cret.", first_name: "Enrique", last_name: "Jugaror", tenant: deportivo)
td_aca =User.create!(email: "delegado1@academy1.com", password: "s3cret.", first_name: "María", last_name: "Delegado", tenant: academia)
td_dep =User.create!(email: "delegado1@academy2.com", password: "s3cret.", first_name: "Josefa", last_name: "Delegado", tenant: deportivo)


# SuperAdmin for Tenants  
Role.find_or_create_by(name: :super_admin, resource: root_tenant, tenant: su.tenant)

# TenantAdmin for Academies
Role.find_or_create_by(name: :tenant_admin, resource: academia, tenant: ta_aca.tenant)
Role.find_or_create_by(name: :tenant_admin, resource: deportivo, tenant: ta_dep.tenant)
Role.find_or_create_by(name: :staff_assistant, resource: academia, tenant: sa_aca.tenant)
Role.find_or_create_by(name: :staff_assistant, resource: deportivo, tenant: sa_dep.tenant)
Role.find_or_create_by(name: :coach, resource: academia, tenant: co_aca.tenant)
Role.find_or_create_by(name: :coach, resource: deportivo, tenant: co_dep.tenant)
Role.find_or_create_by(name: :player, resource: academia, tenant: ju_aca.tenant)
Role.find_or_create_by(name: :player, resource: deportivo, tenant: ju_dep.tenant)
Role.find_or_create_by(name: :team_assistant, resource: academia, tenant: td_aca.tenant)
Role.find_or_create_by(name: :team_assistant, resource: deportivo, tenant: td_dep.tenant)

# Role Assignments
su.add_role(:super_admin, root_tenant)
ta_aca.add_role(:tenant_admin, academia)
ta_dep.add_role(:tenant_admin, deportivo)
sa_aca.add_role(:staff_assistant, academia)
sa_dep.add_role(:staff_assistant, deportivo)
co_aca.add_role(:coach, academia)
co_dep.add_role(:coach, deportivo)
ju_aca.add_role(:player, academia)
ju_dep.add_role(:player, deportivo)
td_aca.add_role(:team_assistant, academia)
td_dep.add_role(:team_assistant, deportivo)

ActsAsTenant.with_tenant(academia) { Player.create(email: "nachitoolivo@gmail.com", tenant: academia) }
ActsAsTenant.with_tenant(deportivo) { Player.create(email: "doriona@gmail.com", tenant: deportivo) }
