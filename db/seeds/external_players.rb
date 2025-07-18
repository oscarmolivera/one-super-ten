academia = Tenant.find(2)
allowed_users = num = User.all.select { |u|  u.roles.first.name != 'player' && u.tenant_id == academia.id && u.roles.first.name != 'assistant_coach'  }.map{ |us| us.id }
dice = [true, true, true, false, true, true, true, true, true, true,true, true, true, true, false, true, true, true, true, true]
50.times do |i|
  document_number = Faker::Number.number(digits: 8) if dice.sample
  birthday = Date.new(rand(2008..2020), rand(1..12), rand(1..28))
  ExternalPlayer.create!(
    tenant_id: academia.id,
    user_id: allowed_users.sample, 
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    document_number: document_number,
    date_of_birth: birthday,
    gender: dice.sample ? 'hombre' : 'mujer',
    position: %w[delantero mediocampo defensa portero lateral].sample,
    jersey_number: rand(1..99),
    notes: Faker::Sports::Football.team,
    is_active: dice.sample 
  )
end