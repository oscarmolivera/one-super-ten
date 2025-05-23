module Players
  class AssignCategory
    def initialize(player)
      @player = player
    end

    def call
      return unless @player.date_of_birth.present?
      
      set_category_to_player(@player)
    end
    
    private
    
    def set_category_to_player(player)
      categories_for_player(player).compact.each do |category|
        player.categories << category unless player.categories.include?(category)
      end
    end
    
    def categories_for_player(player)
      player.schools.map do |school|
        school_category_slug = if birthday_passed_this_year?(player.date_of_birth)
                                 "sub_#{age(player.date_of_birth) + 1}"
                               else
                                 "sub_#{age(player.date_of_birth) + 2}"
                               end
        school.categories.find_by(slug: school_category_slug)
      end
    end

    def birthday_passed_this_year?(date_of_birth)
      return false unless date_of_birth

      today = Date.today
      birthday_this_year = Date.new(today.year, date_of_birth.month, date_of_birth.day)
      today >= birthday_this_year
    end

    def age(date_of_birth)
      return unless date_of_birth

      today = Date.today
      age = today.year - date_of_birth.year
      age -= 1 if today < Date.new(today.year, date_of_birth.month, date_of_birth.day)
      age
    end
  end
end