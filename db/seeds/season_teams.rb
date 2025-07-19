SeasonTeamRival.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('season_team_rivals')
Rival.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('rivals')
SeasonTeamPlayer.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('season_team_players')
Inscription.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('inscriptions')
SeasonTeam.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('season_teams')

academia = Tenant.find(2)
tenant_all_tournaments = Tournament.where(tenant: academia ).where(public: :true)
academia_coaches = User.where(tenant: academia).select {|u| u.has_role?(:coach, academia)}
user = User.find(2)
logos_id = %W[1 2 3 4 5 6 7 8]
@positions = %W[ portero defensa defensa defensa defensa mediocampo mediocampo mediocampo mediocampo mediocampo lateral lateral lateral lateral delantero delantero delantero]
number_teams = [3, 5, 7, 9, 11]

def player_hash(season_team)
  jersey_numbers = {}
  positions = {}
  players_ids = season_team.category.player_ids
  players_ids.each { |id| jersey_numbers[id] = rand(1..99).to_s }
  players_ids.each { |id| positions[id] = @positions.sample }
  {
    player_ids: players_ids.map(&:to_s),
    jersey_numbers: jersey_numbers,
    positions: positions
  }
end

tenant_all_tournaments.each do |tournament|
  category_list = tournament.categories.pluck(:id)
  3.times do |i|
    category = Category.find(category_list.first)
    category_list.shift(1)
    coach = academia_coaches.sample
    assistant = AssistantAssignment.where(coach_id: coach.id).sample
    season_team = SeasonTeam.create!(
      tenant_id: academia.id,
      category_id: category.id,
      tournament_id: tournament.id,
      name: "Equipo * #{category.slug} - #{Faker::University.name}",
      created_by_id: user.id,
      coach_id: coach.id,
      assistant_coach_id: assistant.assistant_id,
      team_assistant_id: 8
    )
    Inscription.create!(
      tournament_id: tournament.id,
      category_id: category.id,
      season_team_id: season_team.id,
      creator_id: user.id,
    )

    Inscriptions::AssignPlayersToSeasonTeamService.new(season_team, player_hash(season_team)).call

    number_teams.sample.times do |i|
      logo_file = "rival-logo-#{logos_id.sample}.png"
      rival = Rival.create(
        tenant: academia,
        name: [Faker::App.name, Faker::Bank.name, Faker::Beer.name, "#{Faker::Adjective.positive} F.C."].sample.capitalize,
        location: [Faker::Address.state, Faker::Commerce.material, Faker::Hipster.words.first].sample.capitalize,
        active: true,
        is_favorite: false
      ).tap do |rival|
        rival.team_logo.attach(
          io: File.open(Rails.root.join("app/assets/images/#{logo_file}")),
          filename: "#{logo_file}",
          content_type: "image/png"
        )
      end
      SeasonTeamRival.create(
        tenant: academia,
        season_team_id: season_team.id,
        rival_id: rival.id
      )
    end
  end
  puts "Fin Torneo #{tournament.name} ***"
end

