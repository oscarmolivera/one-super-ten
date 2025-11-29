class KnockoutJourneyPresenter
  def initialize(season_team)
    @season_team = season_team
  end

  def call
    {
      current_phase: @season_team.current_stage&.phase,
      phases: build_phases,
      eliminated?: @season_team.eliminated?,
      final_result: 'A ser determinado'
    }
  end

  private

  def build_phases
    @season_team.stages.knockout.order(:order).map do |stage|
      match = match_for_stage(stage)
      {
        phase_key: stage.phase,
        phase_label: stage.phase.to_s.humanize,
        stage: stage,
        match: match,
        status: status_for(match),
        advanced: advanced_from?(match),
        rival: rival_for(stage)
      }
    end
  end

  def match_for_stage(stage)
    stage.matches.first
  end

  def status_for(match)
    match.status
  end

  def rival_for(stage)
    stage.matches.first.rival
  end
  
  def advanced_from?(match)
    
  end
end