class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[show edit update destroy]
  before_action :set_cup
  before_action :set_school_categories, only: %i[new edit]
  before_action :authorize_tournament

  def index
    @tournaments = policy_scope(@cup.tournaments)
  end

  def show
  end

  def new
    @tournament = @cup.tournaments.build
  end

  def create
    @tournament = @cup.tournaments.build(tournament_params.except(:category_ids))
    @tournament.tenant = @cup.tenant

    if @tournament.save
      @tournament.category_ids = tournament_params[:category_ids]
      redirect_to cup_tournaments_path(@tournament.cup), notice: "Torneo creado exitosamente."
    else
      Rails.logger.info "XXXXXXXXX........-> #{@tournament.errors.full_messages.to_sentence}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @tournament.update(tournament_params)
      redirect_to cup_tournaments_path(@tournament.cup), notice: "Torneo actualizado exitosamente."
    else
      render :edit
    end
  end

  def destroy
    @tournament.destroy
    redirect_to cup_tournaments_path, notice: 'Tournament deleted.'
  end

  private

  def set_cup
    @cup = Cup.find(params[:cup_id])
  end

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def authorize_tournament
    authorize :tournament, :index?
  end
  def set_school_categories
    @categories = School.find(@cup.school_id).categories.order(id: :asc)
  end

  def tournament_params
    params.require(:tournament).permit(
      :name, :description, :start_date, :end_date, :status, :public, :rules, :cup_id, category_ids: []
    )
  end
end