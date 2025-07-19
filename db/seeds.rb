require 'faker'
puts "Seeding tenants..."
ActiveRecord::Base.connection.execute <<-SQL
  INSERT INTO tenants (name, subdomain, created_at, updated_at, parent_tenant_id)
  VALUES ('Main Tenant', 'main', '#{Time.current}', '#{Time.current}', NULL),
  ('Academia Margarita', 'academia-margarita', '#{Time.current}', '#{Time.current}', 1),
  ('Deportivo Margarita', 'deportivo-margarita', '#{Time.current}', '#{Time.current}', 1);
SQL

root_tenant = Tenant.find_by(subdomain: "main")
academia = Tenant.find_by(subdomain: "academia-margarita")
deportivo = Tenant.find_by(subdomain: "deportivo-margarita")

puts "Seeding categories..."
load Rails.root.join("db/seeds/categories.rb")

categorias = []
Category.all.each do |cat|
  categorias << cat
end

puts "Seeding USers..."
su = User.create!(email: "admin@nubbe.net", password: "s3cret.", first_name: "Super Admin", last_name: "Nubbe.Net", tenant: root_tenant)
ta_aca =User.create!(email: "admin@academia.com", password: "s3cret.", first_name: "Luis", last_name: "TenantAdmin", tenant: academia)
ta_dep = User.create!(email: "admin@deportivo.com", password: "s3cret.", first_name: "Gilberto", last_name: "TenantAdmin", tenant: deportivo)
sa_aca =User.create!(email: "administrador@academy1.com", password: "s3cret.", first_name: "Miriam", last_name: "StaffAdmin", tenant: academia)
sa_dep =User.create!(email: "administrador@academy2.com", password: "s3cret.", first_name: "Alberto", last_name: "StaffAdmin", tenant: deportivo)
co_aca =User.create!(email: "entrenador@academy1.com", password: "s3cret.", first_name: "Rodrigo", last_name: "Coach", tenant: academia)
co_dep =User.create!(email: "entrenador@academy2.com", password: "s3cret.", first_name: "Samuel", last_name: "Coach", tenant: deportivo)
td_aca =User.create!(email: "delegado1@academy1.com", password: "s3cret.", first_name: "María", last_name: "Delegado", tenant: academia)
td_dep =User.create!(email: "delegado1@academy2.com", password: "s3cret.", first_name: "Josefa", last_name: "Delegado", tenant: deportivo)


puts "Seeding Roles..."
# SuperAdmin for Tenants  
Role.find_or_create_by(name: :super_admin, resource: root_tenant, tenant: su.tenant)

# TenantAdmin for Academies
Role.find_or_create_by(name: :tenant_admin, resource: academia, tenant: ta_aca.tenant)
Role.find_or_create_by(name: :tenant_admin, resource: deportivo, tenant: ta_dep.tenant)
Role.find_or_create_by(name: :staff_assistant, resource: academia, tenant: sa_aca.tenant)
Role.find_or_create_by(name: :staff_assistant, resource: deportivo, tenant: sa_dep.tenant)
Role.find_or_create_by(name: :coach, resource: academia, tenant: co_aca.tenant)
Role.find_or_create_by(name: :coach, resource: deportivo, tenant: co_dep.tenant)
Role.find_or_create_by(name: :player, resource: academia, tenant: academia)
Role.find_or_create_by(name: :player, resource: deportivo, tenant: deportivo)
Role.find_or_create_by(name: :team_assistant, resource: academia, tenant: td_aca.tenant)
Role.find_or_create_by(name: :team_assistant, resource: deportivo, tenant: td_dep.tenant)
Role.find_or_create_by(name: :player, resource: academia, tenant: academia)
Role.find_or_create_by(name: :player, resource: deportivo, tenant: deportivo)

# Role Assignments
su.add_role_with_tenant(:super_admin, root_tenant)
ta_aca.add_role_with_tenant(:tenant_admin, academia)
ta_dep.add_role_with_tenant(:tenant_admin, deportivo)
sa_aca.add_role_with_tenant(:staff_assistant, academia)
sa_dep.add_role_with_tenant(:staff_assistant, deportivo)
co_aca.add_role_with_tenant(:coach, academia)
co_dep.add_role_with_tenant(:coach, deportivo)
td_aca.add_role_with_tenant(:team_assistant, academia)
td_dep.add_role_with_tenant(:team_assistant, deportivo)

load Rails.root.join("db/seeds/players.rb")

puts "Seeding Coachs..."
CoachProfile.create!( user: co_aca, hire_date: rand(2..5).years.ago, salary: rand(1500..3000))
CoachProfile.create!( user: co_dep, hire_date: rand(2..5).years.ago, salary: rand(1500..3000))

# Create demo Coaches
10.times do |i|
  coach_name = Faker::Name.first_name_men
  coach_surname = Faker::Name.last_name
  user = User.create!(
    email: "#{(coach_name).downcase}.#{(coach_surname).downcase}#{i}@academia.com",
    password: "s3cret.",
    first_name: coach_name,
    last_name: coach_surname,
    tenant_id: academia.id
  )
  user.add_role(:coach, academia)

  CoachProfile.create!(
    user: user,
    hire_date: rand(2..5).years.ago,
    salary: rand(1500..3000)
  )

  # Create demo Assistant Coaches
  3.times do |i|
    coach_assist_name = Faker::Name.first_name_men
    coach_assist_surname = Faker::Name.last_name
    user = User.create!(
      email: "#{(coach_assist_name).downcase}.#{(coach_assist_surname).downcase}#{i}@academia.com",
      password: "s3cret.",
      first_name: coach_assist_name,
      last_name: coach_assist_surname,
      tenant_id: academia.id
    )
    user.add_role(:assistant_coach, academia) # Use a different role for assistants
  end
end

# Assign Assistants to Coaches randomly
CoachProfile.all.each do |coach_profile|
  coach = coach_profile.user
  assistants = User.with_role(:assistant_coach, academia).sample(2) # Assign 2 assistants
  assistants.each do |assistant|
    AssistantAssignment.create!(coach: coach, assistant: assistant)
  end
end


puts "Seeding ExternalPlayers..."
load Rails.root.join("db/seeds/external_players.rb")

puts "Seeding Cups & Tournaments..."
load Rails.root.join("db/seeds/cups_and_tournaments.rb")

puts "Seeding SeasonTeams..."
load Rails.root.join("db/seeds/season_teams.rb")

puts "Seeding Matches..."
load Rails.root.join("db/seeds/matches.rb")