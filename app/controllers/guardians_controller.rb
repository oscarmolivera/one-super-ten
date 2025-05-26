class GuardiansController < ApplicationController
  before_action :set_player
  before_action :set_tenant

  def create
    authorize :guardian, :index?
    @guardian = @player.guardians.new(guardian_params)
    @guardian.tenant = ActsAsTenant.current_tenant

    if @guardian.save
      redirect_to edit_player_path(@player, anchor: 'guardiandata'), notice: "Responsable creado exitosamente."
    else
      Rails.logger.error "Guardian creation failed: #{@guardian.errors.full_messages.join(', ')}"
      redirect_to edit_player_path(@player, anchor: 'guardiandata'), notice: "No creado el responsable. Por favor, revisa los datos ingresados."
    end
  end

  private

  def set_player
    @player = Player.find(params[:player_id])
  end

  def set_tenant
    ActsAsTenant.current_tenant = @player.tenant
  end

  def guardian_params
    params.require(:guardian).permit(:first_name, :last_name, :email, :phone, :gender, :relationship, :address, :notes)
  end
end