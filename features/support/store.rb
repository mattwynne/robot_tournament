RobotTournament.base_dir = RobotTournament.base_dir + '/tmp/cucumber'

Before do
  TournamentStore.new.clear
end