module CurrentTournament
  def tournament
    TournamentStore.new.current
  end
end