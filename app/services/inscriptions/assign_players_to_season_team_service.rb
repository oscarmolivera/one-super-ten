module Inscriptions
  class AssignPlayersToSeasonTeamService
    def initialize(season_team, params)
      @season_team = season_team
      @params = params
    end

    def call
      prepare_data
      remove_unselected_players
      add_new_players
      update_existing_players
      add_external_players
    end

    private

    def prepare_data
      @selected_ids = Array(@params[:player_ids]).map(&:to_i)
      @reinforcement_ids = Array(@params[:reinforcement_player_ids])
      @external_ids = Array(@params[:external_player_ids]).reject(&:blank?)
      @jersey_numbers = @params[:jersey_numbers] || {}
      @positions = @params[:positions] || {}
      @final_ids = @selected_ids + @reinforcement_ids

      @current_ids = @season_team.season_team_players.pluck(:player_id)

      @category = @season_team.category
      @slug_number = @category.slug[/\d+/].to_i
      @school_id = @category.school.id

      @lower_category = Category.find_by("slug LIKE ? AND school_id = ?", "sub_#{@slug_number + 1}", @school_id)
      @upper_category = Category.find_by("slug LIKE ? AND school_id = ?", "sub_#{@slug_number - 1}", @school_id)
    end

    def remove_unselected_players
      to_remove = @current_ids - @final_ids
      @season_team.season_team_players.where(player_id: to_remove).destroy_all
    end

    def add_new_players
      (@final_ids - @current_ids).each do |id|
        player = Player.find(id)
        last_stp = SeasonTeamPlayer.joins(:season_team)
                    .where(player: player, season_teams: { category_id: @category.id })
                    .order(created_at: :desc).first

        jersey = @jersey_numbers[id.to_s].presence&.to_i || last_stp&.jersey_number || player.player_profile&.jersey_number ||
                    rand(1..99)
        position = @positions[id.to_s] || last_stp&.position || player.position || %w[portero defensa medio delantero].sample

        origin, player_category_id = origin_and_category(player)

        @season_team.season_team_players.create!(
          player_id: player.id,
          origin: origin,
          category_id: player_category_id,
          jersey_number: jersey,
          position: position,
          starter: true
        )
      end
    end

    def update_existing_players
      (@final_ids & @current_ids).each do |id|
        stp = @season_team.season_team_players.find_by(player_id: id)
        next unless stp

        stp.update(
          jersey_number: @jersey_numbers[id.to_s].presence || stp.jersey_number,
          position: @positions[id.to_s].presence || stp.position
        )
      end
    end

    def add_external_players
      @external_ids.each do |id|
        player = ExternalPlayer.find(id)

        @season_team.season_team_players.create!(
          external_player_id: player.id,
          origin: :external,
          jersey_number: player.jersey_number,
          position: player.position || 'por definir',
          starter: true
        )
      end
    end

    def origin_and_category(player)
      if @selected_ids.include?(player.id)
        [:main_category, @category.id]
      elsif @lower_category&.players&.pluck(:id)&.include?(player.id)
        [:below_category, @lower_category.id]
      elsif @upper_category&.players&.pluck(:id)&.include?(player.id)
        [:above_category, @upper_category.id]
      else
        [:external, 0]
      end
    end
  end
end