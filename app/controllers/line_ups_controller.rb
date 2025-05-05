class LineUpsController < ApplicationController
  before_action :set_match
  before_action :set_line_up, only: [:edit, :update]

  def new
    authorize :line_up, :index?
    @line_up = @match.line_ups.new
    @call_up_players = @match.call_ups.last&.call_up_players.includes(:player) || []
  end

  def create
    authorize :line_up, :index?

    @line_up = @match.line_ups.new(line_up_params)

    if @line_up.save
      redirect_to match_path(@match), notice: "LineUp created successfully."
    else
      @call_up_players = @match.call_ups.last&.call_up_players.includes(:player) || []
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize :line_up, :index?

    @call_up_players = @match.call_ups.last&.call_up_players.includes(:player) || []
  end

  def update
    authorize :line_up, :index?

    if @line_up.update(line_up_params)
      redirect_to match_path(@match), notice: "LineUp updated successfully."
    else
      @call_up_players = @match.call_ups.last&.call_up_players.includes(:player) || []
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_match
    @match = Match.find(params[:match_id])
  end

  def set_line_up
    @line_up = @match.line_ups.find(params[:id])
  end

  def line_up_params
    params.require(:line_up).permit(:call_up_player_id, :position, :jersey_number, :role)
  end
end