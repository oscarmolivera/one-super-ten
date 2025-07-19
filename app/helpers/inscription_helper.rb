module InscriptionHelper
  def register_by(ext_player)
    User.find(ext_player.user_id).full_name if ext_player.user_id.present?
  end

  def inscription_form_options(inscription, tournament)
    {
      url:    inscription.persisted? ?
                cup_tournament_inscription_path(tournament.cup, tournament, inscription) :
                cup_tournament_inscriptions_path(tournament.cup, tournament),
      method: inscription.persisted? ? :patch : :post   # let the verb match the record state
    }
  end
end
