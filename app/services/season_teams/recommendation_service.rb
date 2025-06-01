module SeasonTeam
  class RecommendationService
    def initialize(season_team)
      @season_team = season_team
      @category = season_team.category
    end

    def recommended_players
      category_ids = [@category.id]
      category_ids << previous_category_id if previous_category_id
      category_ids << next_category_id if next_category_id

      Player.joins(:category_players)
        .where(category_players: { category_id: category_ids })
        .distinct
        .select do |player|
          origin_for(player).present?
        end.map do |player|
          {
            player: player,
            origin: origin_for(player)
          }
        end
    end

    private

    def previous_category_id
      Category.where('id < ?', @category.id).order(id: :desc).limit(1).pluck(:id).first
    end

    def next_category_id
      Category.where('id > ?', @category.id).order(id: :asc).limit(1).pluck(:id).first
    end

    def origin_for(player)
      return 'main_category' if player.categories.include?(@category)
      return 'below_category' if player.categories.pluck(:id).include?(previous_category_id) && player.date_of_birth.present? && player.date_of_birth > 12.years.ago.to_date
      return 'above_category' if player.categories.pluck(:id).include?(next_category_id) && player.gender == 'female' && player.date_of_birth > 14.years.ago.to_date
      nil
    end
  end
end