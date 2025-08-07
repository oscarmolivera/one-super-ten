module CallUps
  class UpdateService
    def initialize(call_up:, params:)
      @call_up = call_up
      @params = params
    end

    def call
      # Always recombine and assign date+time before transaction
      assign_call_up_datetime!

      selected_player_ids = Array(@params[:player_ids]).reject(&:blank?).map(&:to_i)
      selected_external_ids = Array(@params[:external_player_ids]).reject(&:blank?).map(&:to_i)

      current_player_ids = @call_up.call_up_players.pluck(:player_id).compact
      current_external_ids = @call_up.call_up_players.pluck(:external_player_id).compact

      player_ids_to_add = selected_player_ids - current_player_ids
      player_ids_to_remove = current_player_ids - selected_player_ids

      external_ids_to_add = selected_external_ids - current_external_ids
      external_ids_to_remove = current_external_ids - selected_external_ids

      # If nothing selected, destroy the CallUp
      if selected_player_ids.empty? && selected_external_ids.empty?
        @call_up.destroy
        return OpenStruct.new(success?: true, destroyed?: true)
      end

      ActiveRecord::Base.transaction do
        # Remove deselected players
        @call_up.call_up_players.where(player_id: player_ids_to_remove).destroy_all
        @call_up.call_up_players.where(external_player_id: external_ids_to_remove).destroy_all

        # Insert new Player rows
        if player_ids_to_add.any?
          # Preload player categories in one query for efficiency
          player_categories = CategoryPlayer.where(player_id: player_ids_to_add)
                                          .group_by(&:player_id)
          rows = player_ids_to_add.map do |pid|
            category_id = player_categories[pid]&.first&.category_id
            {
              call_up_id: @call_up.id,
              player_id: pid,
              player_category_id: category_id,
              attendance: false,
              created_at: Time.zone.now,
              updated_at: Time.zone.now
            }
          end
          CallUpPlayer.insert_all(rows)
        end

        # Insert new ExternalPlayer rows
        if external_ids_to_add.any?
          rows = external_ids_to_add.map do |eid|
            {
              call_up_id: @call_up.id,
              external_player_id: eid,
              attendance: false,
              created_at: Time.zone.now,
              updated_at: Time.zone.now
            }
          end
          CallUpPlayer.insert_all(rows)
        end

        # Update main CallUp record, including call_up_date
        @call_up.update!(
          name: @params[:name],
          match_id: @params[:match_id],
          category_id: @params[:category_id],
          call_up_date: @call_up.call_up_date # ensure the recombined datetime is saved
        )
      end

      OpenStruct.new(success?: true, destroyed?: false)
    rescue ActiveRecord::RecordInvalid
      OpenStruct.new(success?: false, destroyed?: false)
    end

    private

    def assign_call_up_datetime!
      date = @params[:call_up_date_only].presence || @call_up.call_up_date&.to_date&.to_s
      time = @params[:call_up_time_only].presence

      if date.present? && time.present?
        @call_up.call_up_date = Time.zone.parse("#{date} #{time}")
      elsif date.present?
        # If only date is present, keep the original time or set to midnight
        original_time = @call_up.call_up_date&.strftime("%H:%M") || "00:00"
        @call_up.call_up_date = Time.zone.parse("#{date} #{original_time}")
      end
      # If neither present, do not change call_up_date
    end
  end
end