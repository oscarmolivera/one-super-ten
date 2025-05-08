
puts "🌱 Seeding Matches..."

[Tenant.find_by(subdomain: "academia-margarita"), Tenant.find_by(subdomain: "deportivo-margarita")].each do |tenant|
  ActsAsTenant.with_tenant(tenant) do
    puts "➡️  Tenant: #{tenant.name}"

    categories = tenant.categories.limit(2)

    categories.each do |category|
      puts "  📦 Category: #{category.name}"

      3.times do
        match = Match.create!(
          match_type: Match.match_types.keys.sample,
          opponent_name: Faker::Sports::Football.team,
          location: Faker::Address.city,
          scheduled_at: rand(1..10).days.from_now.change(hour: 16),
          home_score: rand(0..3),
          away_score: rand(0..3),
          notes: Faker::Lorem.sentence,
          tournament_id: nil
        )

        call_up = CallUp.create!(
          name: "CallUp vs #{match.opponent_name}",
          call_up_date: match.scheduled_at - 2.days,
          category: category,
          match: match,
          tenant: tenant,
          status: :notified
        )

        selected_players = category.players.sample(10)
        selected_players.each do |player|
          CallUpPlayer.create!(
            call_up: call_up,
            player: player,
            attendance: %i[present absent unknown].sample
          )

          MatchPerformance.create!(
            match: match,
            player: player,
            goals: rand(0..2),
            assists: rand(0..2),
            minutes_played: rand(45..90),
            yellow_cards: [0, 1].sample,
            red_cards: [0, 0, 1].sample,
            notes: Faker::Lorem.words(number: 5).join(" ")
          )
        end

        puts "    ✅ Match vs #{match.opponent_name} created with #{selected_players.size} players"
      end
    end
  end
end
