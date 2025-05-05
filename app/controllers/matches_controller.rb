class MatchesController < ApplicationController
  before_action :set_match, only: %i[show update_performances]
  
  def index
    @category = Category.find(params[:category_id])
    authorize @category, :show?  # This is for access control to the category

    matches = @category.matches.includes(:call_ups).order(scheduled_at: :desc)
    @matches = policy_scope(matches)
  end

  def show
    authorize :match, :index?
    @line_ups = @match.line_ups.includes(call_up_player: :player)
  end

  def update_performances
    authorize :match, :index?

    params[:performances].each do |id, attrs|
      perf = @match.match_performances.find(id)
      perf.update(attrs.permit(:minutes_played, :goals, :assists, :yellow_cards, :red_cards, :notes))
    end

    redirect_to match_path(@match), notice: "Player performances updated."
  end

  def new
    @match = Match.new
    authorize :match, :index?
    @category = Category.find_by(id: params[:category_id]) if params[:category_id]
  end

  def create
    @match = Match.new(match_params)
    @match.tenant = ActsAsTenant.current_tenant
    authorize :match, :index?


    if @match.save
      if params[:category_id].present?
        # Create a default CallUp linked to this match and category
        CallUp.create!(
          tenant: ActsAsTenant.current_tenant,
          match: @match,
          category_id: params[:category_id],
          name: "Auto CallUp for #{@match.opponent_name}",
          call_up_date: Time.current
        )
      end

      redirect_to match_path(@match), notice: "Match created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def match_params
    params.require(:match).permit(:opponent_name, :location, :scheduled_at, :match_type, :tournament_id, :home_score, :away_score, :notes)
  end

  def set_match
    @match = Match.find(params[:id])
  end
end