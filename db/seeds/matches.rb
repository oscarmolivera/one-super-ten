Match.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('matches')

academia = Tenant.find(2)
SeasonTeam.all.each_with_index do |st, index|
  st.rivals.each do |rival|
    match = Match.new
    match.update(
      tenant: academia,
      tournament_id: st.tournament.id,
      team_of_interest_id: st.id,
      rival_id: rival.id,
      plays_as: [0, 1].sample,
      match_type: 1,
      location: "#{Faker::Address.city}",
      location_type: [0, 1, 2].sample,
      status: 0,
      scheduled_at: Date.today + rand(1..60).days
    )
  end
  puts "SeasonTeam #{index}/ de #{SeasonTeam.all.count-1}"
end