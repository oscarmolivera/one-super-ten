academia = Tenant.find_by(subdomain: "academia-margarita")
deportivo = Tenant.find_by(subdomain: "deportivo-margarita")
tenants = [academia, deportivo]
puts "Seeding Players..."
160.times do |i|
  p '.' if i % 10 == 0
  tenant = tenants.sample
  school = tenant.schools.sample
  category = school.categories.sample
  nombre = Faker::Name.first_name
  apellido = Faker::Name.last_name
  birthday = Date.new(rand(2007..2019), rand(1..12), rand(1..28))
  position = %w[delantero mediocampo defensa portero].sample
  email = "#{Faker::Internet.email}"

  user = User.create!(
    email: email,
    password: 's3cret.',
    tenant_id: tenant.id,
    first_name: nombre,
    last_name: apellido,
  )
  
  user.add_role(:player, tenant)

  dice = [true, true, true, false, true, true, true, true, true, true]
  usuario_id = user.id if dice.sample

  player = Player.create!(
    email: email,
    tenant_id: tenant.id,
    first_name: nombre,
    last_name: apellido,
    date_of_birth: birthday,
    gender: dice.sample ? 'hombre' : 'mujer',
    nationality: dice.sample ? 'venezolano' : 'extranjero',
    document_number: Faker::Number.number(digits: 8),
    dominant_side: dice.sample ? 'derecho' : 'izquierdo',
    position: position,
    address: Faker::Address.full_address,
    is_active: true,
    bio: Faker::Lorem.paragraph,
    notes: Faker::Lorem.sentence,
    user_id: usuario_id, 
  )

  PlayerSchool.find_or_create_by!(player: player, school: school)
  CategoryPlayer.find_or_create_by!(player: player, category: category)
  
end