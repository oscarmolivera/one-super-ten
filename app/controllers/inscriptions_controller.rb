class InscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tournament
  before_action :authorize_tournament

  def index
    @categories = policy_scope(@tournament.categories.order(id: :asc), policy_scope_class: InscriptionPolicy::Scope)
    @existing_inscriptions = @tournament.inscriptions.includes(:category)
  end

  def show; end

  def new
    @category = Category.find(params[:category_id])
    @inscription = Inscription.find_or_initialize_by(tournament: @tournament, category: @category)
    @season_team = @inscription.season_team || @inscription.build_season_team

    @category_players = @category.players
    @previous_team_player_ids = @season_team.players.pluck(:id)

    slug_number = @category.slug[/\d+/].to_i
    @lower_category = Category.find_by("slug LIKE ?", "sub_#{slug_number + 1}")
    @upper_category = Category.find_by("slug LIKE ?", "sub_#{slug_number - 1}")
    @lower_players = @lower_category.present? ? @lower_category.players : []
    @upper_players = @upper_category.present? ? @upper_category.players.where(gender: 'mujer') : []

  end

  def create
    category = Category.find(inscription_params[:category_id])

    @inscription = Inscription.new(
      tournament: @tournament,
      category: category,
      creator: current_user
    )

    if @inscription.save
      assign_players(@inscription.season_team)
      redirect_to cup_tournament_path(@tournament.cup, @tournament), notice: "Inscripción realizada correctamente."
    else
      @categories = @tournament.categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update; end

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
      invited_player_names: [] # free-text input, optional
    )
  end

  def assign_players(season_team)
    category = season_team.category

    slug_number = category.slug[/\d+/].to_i

    lower_category = Category.find_by("slug LIKE ?", "sub_#{slug_number + 1}")
    upper_category = Category.find_by("slug LIKE ?", "sub_#{slug_number - 1}")

    lower_players = lower_category&.players || []
    upper_players = upper_category&.players&.where(gender: 'mujer') || []

    player_ids = Array(inscription_params[:player_ids])
    reinforcement_ids = Array(inscription_params[:reinforcement_player_ids])
    invited_names = Array(inscription_params[:invited_player_names]).reject(&:blank?)

    # 1. Add main category players
    player_ids.each do |id|
      season_team.season_team_players.create!(
        player_id: id,
        origin: :main_category
      )
    end

    # 2. Add reinforcement players
    reinforcement_ids.each do |id|
      player = Player.find(id)

      origin = if lower_players.map(&:id).include?(player.id)
                :below_category
              elsif upper_players.map(&:id).include?(player.id)
                :above_category
              else
                :external
              end

      season_team.season_team_players.create!(
        player_id: player.id,
        origin: origin,
        starter: true
      )
    end

    # 3. Add invited players
    invited_names.each do |name|
      invited = Player.create!(
        first_name: name,
        tenant: season_team.tenant,
        invited: true
      )

      season_team.season_team_players.create!(
        player: invited,
        origin: :external
      )
    end
  end
end