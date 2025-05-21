module PlayersHelper
  def category_card_class(player, category)
    if player.categories.include?(category)
      "card border-success bg-success text-white"
    elsif player.categories.any?
      "card border-info"
    else
      "card border-primary"
    end
  end

  def player_profile_image(player, options = {})
    if player.profile_picture.attached?
      image_tag(
        player.profile_picture,
        {
          alt: "Foto de perfil",
          class: "rounded-circle"
        }.merge(options)
      )
    else
      content_tag(:div,
        content_tag(:i, "", class: "fas fa-user-slash"),
        {
          class: "img-thumbnail d-flex align-items-center justify-content-center",
          style: "width: 35px; height: 35px; background-color: #f0f0f0;"
        }.merge(options)
      )
    end
  end

  def teammate_profile_picture(player)
    if player.profile_picture.attached?
      image_tag(
        player.profile_picture.variant(resize_to_fill: [48, 48]),
        {
          class: "rounded-circle",
          alt: player.full_name
        }
      )
    else
      content_tag(:div,
        content_tag(:i, "", class: "fas fa-user-slash"),
        {
          class: "img-thumbnail d-flex align-items-center justify-content-center",
          style: "width: 35px; height: 35px; background-color: #f0f0f0;"
        }
      )
    end
  end

  def position_background_image(player)
    return "position-1.svg" unless player&.position.present?

    case player.position
    when "portero"
      "goalkeeper-1.svg"
    when "defensa"
      "defender-1.svg"
    when "lateral"
      "lateral-1.svg"
    when "mediocampo"
      "midfielder-2.png"
    when "delantero"
      "forward-1.svg"
    else
      "position-1.svg"
    end
  end
end