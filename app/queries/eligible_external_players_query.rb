class EligibleExternalPlayersQuery
  def initialize(category)
    @category = category
  end

  def call
    return ExternalPlayer.none unless @category&.slug

    age = @category.slug[/\d+/].to_i
    cutoff = Date.current.year - (age - 1)

    ExternalPlayer
      .where.not(date_of_birth: nil)
      .where(is_active: true)
      .select do |player|
        year = player.date_of_birth.year
        year == cutoff || year == cutoff + 1 || (year == cutoff - 1 && player.gender == 'mujer')
      end
  end
end