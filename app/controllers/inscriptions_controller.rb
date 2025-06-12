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
    @category = Category.find(params[:category_id])
    form_data = Inscriptions::FormDataLoader.new(
      tournament: @tournament,
      category: @category
    ).call
  
    assign_form_variables(form_data)
  end

  def create
    service = Inscriptions::CreateInscriptionService.new(
      tournament: @tournament,
      current_user: current_user,
      params: inscription_params
    )
  
    @inscription = service.call
  
    if @inscription&.persisted?
      redirect_to cup_tournament_path(@tournament.cup, @tournament), notice: "Inscripción realizada correctamente."
    else
      @categories = @tournament.categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @inscription = @tournament.inscriptions.find_by!(category_id: params[:category_id])
    @category = @inscription.category
  
    form_data = Inscriptions::FormDataLoader.new(
      tournament: @tournament,
      category: @category,
      season_team: @inscription.season_team || @inscription.build_season_team
    ).call
  
    assign_form_variables(form_data)
  end

  def update
    @inscription = @tournament.inscriptions.find(params[:id])
  
    service = Inscriptions::UpdateInscriptionService.new(
      inscription: @inscription,
      params: inscription_params
    )
  
    if service.call
      redirect_to cup_tournament_path(@tournament.cup, @tournament), notice: "Inscripción actualizada correctamente."
    else
      @category = @inscription.category
      form_data = Inscriptions::FormDataLoader.new(
        tournament: @tournament,
        category: @category,
        season_team: @inscription.season_team
      ).call
      assign_form_variables(form_data)
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
      external_player_ids: [],
      invited_player_names: [],
      season_team_attributes: [:id, :coach_id, :assistant_coach_id, :team_assistant_id],
      jersey_numbers: {},
      positions: {}
    )
  end
  
  def assign_form_variables(data)
    @inscription = data[:inscription]
    @season_team = data[:season_team]
    @previous_team_player_ids = data[:previous_team_player_ids]
    @previous_external_player_ids = data[:previous_external_player_ids]
    @category_players = data[:category_players]
    @lower_category = data[:lower_category]
    @lower_players = data[:lower_players]
    @upper_category = data[:upper_category]
    @upper_players = data[:upper_players]
    @external_players = data[:external_players]
  end

end