TournamentStore.new.clear
FileUtils.cp_r(File.dirname(__FILE__) + '/../../games', RobotTournament.base_dir)