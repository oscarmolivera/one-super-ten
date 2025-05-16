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
end