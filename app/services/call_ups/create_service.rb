module CallUps
  class CreateService
    def initialize(match:)
      @match = match
      @tenant = ActsAsTenant.current_tenant
    end

    def call
      return OpenStruct.new(success?: false, error: "Match must have a date") unless @match.scheduled_at.present?

      CallUp.create!(
        tenant: @tenant,
        match: @match,
        category: Category.find(@match.team_of_interest.category_id),
        name: call_up_name(@match),
        call_up_date: @match.scheduled_at
      )

      OpenStruct.new(success?: true, call_up: @match.call_up) if @match.call_up.present?
    end

    def call_up_name(match)
      "Convocatoria vs #{match.rival.name} - #{match.scheduled_at.strftime('%d/%m/%Y')}"
    end
  end
end