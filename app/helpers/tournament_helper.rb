module TournamentHelper
  def tournament_status(tournament)
    case tournament.status
      when 'draft'
        "Creado"
      when 'published'
        "Publicado"
      when 'ongoing'
        "En Curso"
      when 'completed'
        "Finalizado"
    end
  end
end
