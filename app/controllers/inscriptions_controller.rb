class InscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tournament
  before_action :authorize_tournament

  def index
    @categories = policy_scope(@tournament.categories.order(id: :asc), policy_scope_class: InscriptionPolicy::Scope)
    @existing_inscriptions = @tournament.inscriptions.includes(:category)
  end

  def show
    @inscriptions_by_category = @tournament.inscriptions.includes(:season_team).index_by(&:category_id)
  end

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @category = Category.find(params[:category_id])
    @inscription = @tournament.inscriptions.build(category: @category)

    @season_team = SeasonTeam
      .where(category: @category, tenant: ActsAsTenant.current_tenant)
      .order(created_at: :desc)
      .first || SeasonTeam.new
    @external_players = ExternalPlayer.all

    @previous_team_player_ids = @season_team.players.pluck(:id)

    # Load eligible players
    @category_players = @category.players.where(tenant: ActsAsTenant.current_tenant)

    @lower_category = @category.lower_category
    @lower_players = @lower_category.present? ? @lower_category.players.where(tenant: ActsAsTenant.current_tenant) : []

    @upper_category = @category.upper_category
    @upper_players = @upper_category.present? ? @upper_category.players.where(gender: 'mujer', tenant: ActsAsTenant.current_tenant) : []
  end

  def create
    category = Category.find(inscription_params[:category_id])

    @inscription = Inscription.new(
      tournament: @tournament,
      category: category,
      creator_id: current_user.id,
    )

    @inscription.build_season_team(
      tenant: ActsAsTenant.current_tenant,
      tournament: @tournament,
      category: category,
      name: "#{category.sub_name} - #{ @tournament.name }",
      created_by_id: current_user.id,
      coach_id: inscription_params[:season_team_attributes][:coach_id],
      assistant_coach_id: inscription_params[:season_team_attributes][:assistant_coach_id],
      team_assistant_id: inscription_params[:season_team_attributes][:team_assistant_id]
    )

    if @inscription.save
      assign_players(@inscription.season_team)
      redirect_to cup_tournament_path(@tournament.cup, @tournament), notice: "Inscripción realizada correctamente."
    else
      @categories = @tournament.categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @inscription = @tournament.inscriptions.find_by!(category_id: params[:category_id])
    @category = @inscription.category
    @season_team = @inscription.season_team || @inscription.build_season_team

    @category_players = @category.players
    @previous_team_player_ids = @season_team.players.pluck(:id)

    @lower_category = @category.lower_category  
    @lower_players = @lower_category.present? ? @lower_category.players.where(tenant: ActsAsTenant.current_tenant) : []

    @upper_category = @category.upper_category
    @upper_players = @upper_category.present? ? @upper_category.players.where(gender: 'mujer', tenant: ActsAsTenant.current_tenant) : []
  end

  def update
    @inscription = @tournament.inscriptions.find(params[:id])
    @season_team = @inscription.season_team

    # Update coach and assistants
    @season_team.update(
      coach_id: inscription_params[:season_team_attributes][:coach_id],
      assistant_coach_id: inscription_params[:season_team_attributes][:assistant_coach_id],
      team_assistant_id: inscription_params[:season_team_attributes][:team_assistant_id]
    )

    assign_players(@season_team)

    if @inscription.save
      redirect_to cup_tournament_path(@tournament.cup, @tournament), notice: "Inscripción actualizada correctamente."
    else
      @category = @inscription.category
      @category_players = @category.players
      @previous_team_player_ids = []
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def authorize_tournament
    authorize @tournament, :index?
  end

  def inscription_params
    params.require(:inscription).permit(
      :category_id,
      player_ids: [],
      reinforcement_player_ids: [],
      invited_player_names: [],
      season_team_attributes: [:id, :coach_id, :assistant_coach_id, :team_assistant_id],
      jersey_numbers: {},
      positions: {}
    )
  end

  def assign_players(season_team)
    category = season_team.category
    slug_number = category.slug[/\d+/].to_i

    lower_category = Category.find_by("slug LIKE ?", "sub_#{slug_number + 1}")
    upper_category = Category.find_by("slug LIKE ?", "sub_#{slug_number - 1}")

    lower_players = lower_category&.players || []
    upper_players = upper_category&.players&.where(gender: 'mujer') || []

    # Submitted
    selected_player_ids = Array(inscription_params[:player_ids])
    reinforcement_ids   = Array(inscription_params[:reinforcement_player_ids])
    invited_names       = Array(inscription_params[:invited_player_names]).reject(&:blank?)

    final_player_ids = selected_player_ids + reinforcement_ids

    jersey_numbers = inscription_params[:jersey_numbers] || {}
    positions      = inscription_params[:positions] || {}

    # Current
    current_player_ids = season_team.season_team_players.pluck(:player_id)

    # 1. Destroy removed players
    players_to_remove = current_player_ids - final_player_ids
    season_team.season_team_players.where(player_id: players_to_remove).destroy_all

    # 2. Add new players
    players_to_add = final_player_ids - current_player_ids
    players_to_add.each do |id|
      player = Player.find(id)

      last_stp = SeasonTeamPlayer.joins(:season_team)
                  .where(player: player, season_teams: { category_id: category.id })
                  .order(created_at: :desc).first

      jersey_number = jersey_numbers[id.to_s].presence ||
                      last_stp&.jersey_number ||
                      player.player_profile&.jersey_number ||
                      rand(1..99)

      position = positions[id.to_s].presence ||
                last_stp&.position ||
                player.position ||
                %w[portero defensa medio delantero].sample

      origin = if selected_player_ids.include?(id)
                :main_category
              elsif lower_players.map(&:id).include?(player.id)
                :below_category
              elsif upper_players.map(&:id).include?(player.id)
                :above_category
              else
                :external
              end

      season_team.season_team_players.create!(
        player_id: player.id,
        origin: origin,
        jersey_number: jersey_number,
        position: position,
        starter: true
      )
    end

    # 3. Update existing players if jersey or position changed
    (final_player_ids & current_player_ids).each do |id|
      stp = season_team.season_team_players.find_by(player_id: id)
      next unless stp

      submitted_jersey = jersey_numbers[id.to_s].presence
      submitted_position = positions[id.to_s].presence

      stp.update(
        jersey_number: submitted_jersey || stp.jersey_number,
        position: submitted_position || stp.position
      )
    end

    # 4. Add invited external players (always added)
    invited_names.each do |name|
      invited = Player.create!(
        first_name: name,
        tenant: season_team.tenant,
        invited: true,
        jersey_number: rand(1..99),
        position: %w[portero defensa medio delantero].sample
      )

      season_team.season_team_players.create!(
        player: invited,
        origin: :external,
        jersey_number: invited.jersey_number,
        position: invited.position,
        starter: true
      )
    end
  end
end