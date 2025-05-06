# db/seeds.rb
20.times do
  player = Player.order("RANDOM()").first
  start_date = Faker::Date.backward(days: 30)
  end_date = start_date + rand(15..60).days
  reason = Faker::Lorem.sentence

  Exoneration.create!(
    tenant: player.tenant,
    player: player,
    start_date: start_date,
    end_date: end_date,
    reason: reason
  )
end