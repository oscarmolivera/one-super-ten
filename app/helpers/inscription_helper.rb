module InscriptionHelper
  def register_by(ext_player)
    User.find(ext_player.user_id).full_name if ext_player.user_id.present?
  end
end