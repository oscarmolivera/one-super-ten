class ExternalMatchesController < ApplicationController
  before_action :set_tournament

  def index
    authorize :external_match, :index?
    @external_matches = @tournament.external_matches.order(match_date: :desc)
  end

  def new
    authorize :external_match, :index?
    @external_match = @tournament.external_matches.build
  end

  def create
    authorize :external_match, :index?
    @external_match = @tournament.external_matches.build(external_match_params)
    @external_match.tenant = @tournament.tenant
    
    if @external_match.save
      respond_to do |format|
        format.turbo_stream  # Renders app/views/external_matches/create.turbo_stream.erb
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

    def edit
      authorize :external_match, :index?
      @external_match = @tournament.external_matches.build
    end

    def update
      authorize :external_match, :index?
      @external_match = @tournament.external_matches.build(external_match_params)
      if @external_match.update(external_match_params)
        respond_to do |format|
          format.html { redirect_to tournament_path(@tournament), notice: "Result added." }
          format.turbo_stream  # Renders app/views/external_matches/update.turbo_stream.erb
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

  private

  def set_tournament
    @tournament = Tournament.find(params[:external_match][:tournament_id]) unless @tournament
  end

  def external_match_params
    params.require(:external_match).permit(
      :tournament_id, :home_rival_id, :away_rival_id, :home_score, :away_score,
      :match_date, :match_time, :status, :notes
    )
  end
end