class PlayersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize Player
    @players = Player.all
  end
end