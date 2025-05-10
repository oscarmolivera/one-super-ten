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

puts "Seeding Schools..."
fcampo = School.create!(tenant: academia, name:'Futbol Campo', description: 'Escuela de Valores')
fsala = School.create!(tenant: academia, name:'Futbol Sala', description: 'Escuela de Valores')
emas= School.create!(tenant: deportivo, name:'Escuela Masculina', description: 'Futbol Campo de Varones')
efem = School.create!(tenant: deportivo, name:'Escuela Femenina', description: 'Futbol Campo de Mujeres')

puts "Seeding Categories..."
cat_fs8a = Category.create!(tenant: academia, school: fsala, name: 'Categoria Sub 9', description: 'Niños o niñas con 7 o 8 años')
cat_fs9a = Category.create!(tenant: academia, school: fsala, name: 'Categoria Sub 10', description: 'Niños o niñas con 8 o 9 años')
cat_fc8a = Category.create!(tenant: academia, school: fcampo, name: 'Categoria Sub 9', description: 'Niños o niñas con 7 o 8 años')
cat_fc9a = Category.create!(tenant: academia, school: fcampo, name: 'Categoria Sub 9', description: 'Niños o niñas con 7 o 8 años')
cat_hm9a = Category.create!(tenant: deportivo, school: emas, name: 'Categoria Sub 10', description: 'Hombres menores de 10 años')
cat_mj9a = Category.create!(tenant: deportivo, school: efem, name: 'Categoria Sub 10', description: 'Hembras menores de 10 años')
categorias = [cat_fs8a, cat_fc8a, cat_fs9a, cat_fc9a, cat_hm9a, cat_mj9a]

puts "Seeding USers..."
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
Role.find_or_create_by(name: :player, resource: academia, tenant: ju_aca.tenant)
Role.find_or_create_by(name: :player, resource: deportivo, tenant: ju_dep.tenant)
Role.find_or_create_by(name: :team_assistant, resource: academia, tenant: td_aca.tenant)
Role.find_or_create_by(name: :team_assistant, resource: deportivo, tenant: td_dep.tenant)
Role.find_or_create_by(name: :player, resource: academia, tenant: academia)
Role.find_or_create_by(name: :player, resource: deportivo, tenant: deportivo)

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

load Rails.root.join("db/seeds/players.rb")

puts "Seeding Coachs..."
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
end

coach_assist_name = Faker::Name.first_name_men
coach_assist_surname = Faker::Name.last_name
# Create demo Assistant Coaches
10.times do |i|
  user = User.create!(
    email: "#{(coach_assist_name).downcase}.#{(coach_assist_surname).downcase}#{i}@academia.com",
    password: "s3cret.",
    first_name: coach_assist_name,
    last_name: coach_assist_surname,
    tenant_id: academia.id
  )
  user.add_role(:assistant_coach, academia) # Use a different role for assistants
end

# Assign Assistants to Coaches randomly
CoachProfile.all.each do |coach_profile|
  coach = coach_profile.user
  assistants = User.with_role(:assistant_coach, academia).sample(2) # Assign 2 assistants
  assistants.each do |assistant|
    AssistantAssignment.create!(coach: coach, assistant: assistant)
  end
end

puts "Seeding Events..."
events = [
  { title: "Amistoso vs Águilas", event_type: :friendly, allow_reinforcements: true },
  { title: "Torneo Estatal Sub14", event_type: :tournament, external_organizer: true, organizer_name: "Federación Regional" },
  { title: "Partido de práctica", event_type: :match }
]

coach = Role.all.where(name: 'coach', tenant: academia).last.users.last

events.each do |attrs|
  event = Event.create!(
    school: fcampo,
    coach: coach,
    tenant: academia,
    description: "#{attrs[:title]} en cancha sintética",
    start_time: Time.now + rand(1..10).days,
    end_time: Time.now + rand(11..15).days,
    location_name: "Estadio Olímpico",
    location_address: "Calle Fútbol, Caracas",
    **attrs
  )
  event.categories << categorias.sample
end

puts "Seeding Sites..."
Site.create!(
  school_id: fcampo.id,
  name: 'Pozo Viejo',
  address: 'Av Principal Pozo Viejo',
  city: 'Porlamar',
  map_url: '',
  capacity: 150,
  description: 'Una descripcion del sitio'
)

puts "Seeding Training Sessions..."
10.times do |i|
  category = categorias.sample
  coach = User.with_role(:coach, category.tenant).first

  TrainingSession.create!(
    category: category,
    coach: coach,
    site: Site.first,
    scheduled_at: 2.days.from_now,
    duration_minutes: 90,
    objectives: "#{i} - Improve passing and stamina",
    activities: "#{i} -Warm-up, cone drills, 5v5 mini-game",
    notes: "#{i} - All players must bring water"
  )
end

load Rails.root.join("db/seeds/matches-n-callups.rb")

MatchReport.create!(
  tenant: academia,
  match: Match.first,
  user:  CoachProfile.first.user,
  author_role: :coach,
  general_observations: "Game was played under fair weather. Good discipline.",
  incidents: "Minor altercation at 45'. Yellow card to #9.",
  team_claims: "Home team claimed an offside was missed.",
  final_notes: "Game concluded without major issues.",
  reported_at: Time.zone.now
)

puts "Seeding Incomes..."
load Rails.root.join("db/seeds/incomes.rb")

puts "Seeding Expenses..."
load Rails.root.join("db/seeds/expenses.rb")
