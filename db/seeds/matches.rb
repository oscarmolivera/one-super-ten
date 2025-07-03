Match.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('matches')

academia = Tenant.find(2)
dice = [true, true, false, true]
SeasonTeam.all.each_with_index do |st, index|

  stage = Stage.create(
    tournament_id: st.tournament.id,
    season_team_id: st.id,
    name: 'first phase',
    stage_type: 0,
    order: 1
  )

  st.rivals.each do |rival|
    date = dice.sample ? DateTime.now + rand(1..60).days : nil
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
      status: date.present? ? 1 : 0,
      scheduled_at: date,
      referee: dice.sample ? Faker::Name.name : nil,
      stage_id: stage.id
    )
  end
  puts "SeasonTeam #{index}/ de #{SeasonTeam.all.count-1}"
end