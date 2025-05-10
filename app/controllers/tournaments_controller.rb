class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[show edit update destroy]
  before_action :authorize_tournament

  def index
    @tournaments = policy_scope(Tournament)
  end

  def show
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.tenant = ActsAsTenant.current_tenant

    if @tournament.save
      redirect_to tournaments_path, notice: 'Tournament created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to tournament_path(@tournament), notice: 'Tournament updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @tournament.destroy
    redirect_to tournaments_path, notice: 'Tournament deleted.'
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def authorize_tournament
    authorize :tournament, :index?
  end

  def tournament_params
    params.require(:tournament).permit(
      :name, :description, :start_date, :end_date, :status, :public, :rules, category_ids: []
    )
  end
end