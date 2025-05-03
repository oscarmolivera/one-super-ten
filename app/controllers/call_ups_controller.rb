class CallUpsController < ApplicationController
  def new
    authorize :call_up, :index?
    @match = Match.find(params[:match_id])
    @category = Category.joins(:call_ups).find_by(call_ups: { match_id: @match.id })
    @call_up = CallUp.new(match: @match, category: @category)
  end

  def create
    authorize :call_up, :index?
    @call_up = CallUp.new(call_up_params)
    @call_up.tenant = ActsAsTenant.current_tenant

    if @call_up.save
      redirect_to matches_path, notice: "CallUp was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def call_up_params
    params.require(:call_up).permit(
      :match_id,
      :category_id,
      :name,
      :call_up_date,
      player_ids: []
    )
  end
end