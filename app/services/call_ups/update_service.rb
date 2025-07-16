module CallUps
  class UpdateService
    def initialize(call_up:, params:)
      @call_up = call_up
      @params = params
    end

    def call
      recombine_datetime!

      selected_player_ids = @params[:player_ids].reject(&:blank?).map(&:to_i)
      current_player_ids = @call_up.call_up_players.pluck(:player_id)

      ids_to_add = selected_player_ids - current_player_ids
      ids_to_remove = current_player_ids - selected_player_ids

      if selected_player_ids.empty?
        @call_up.destroy
        return OpenStruct.new(success?: true, destroyed?: true)
      end

      ActiveRecord::Base.transaction do
        @call_up.call_up_players.where(player_id: ids_to_remove).destroy_all

        if ids_to_add.any?
          rows = ids_to_add.map do |pid|
            {
              call_up_id: @call_up.id,
              player_id: pid,
              attendance: false,
              created_at: Time.zone.now,
              updated_at: Time.zone.now
            }
          end
          CallUpPlayer.insert_all(rows)
        end

        @call_up.update!(
          name: @params[:name],
          match_id: @params[:match_id],
          category_id: @params[:category_id]
        )
      end

      OpenStruct.new(success?: true, destroyed?: false)
    rescue ActiveRecord::RecordInvalid
      OpenStruct.new(success?: false, destroyed?: false)
    end

    private

    def recombine_datetime!
      date = @params[:call_up_date_only]
      time = @params[:call_up_time_only]

      if date.present? && time.present?
        @call_up.call_up_date = Time.zone.parse("#{date} #{time}")
      end
    end
  end
end