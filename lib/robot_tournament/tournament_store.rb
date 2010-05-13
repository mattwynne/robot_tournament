require 'robot_tournament/tournament'

class TournamentStore
  def initialize
    @dir = RobotTournament.base_dir + '/tournaments'
    FileUtils.mkdir_p(@dir)
  end
  
  def current
    return nil unless current_tournament_exists?
    Tournament.new(current_tournament_path)
  end
  
  def create(settings)
    raise "A Tournament is already in progress!" if current_tournament_exists?
    FileUtils.mkdir_p(current_tournament_path)
    File.open(current_tournament_path + '/settings.json', 'w') do |file|
      file.puts(JSON.generate(settings))
    end
    current
  end
  
  def clear
    FileUtils.rm_rf(@dir)
    FileUtils.mkdir_p(@dir)
  end
  
  private
  
  def current_tournament_path
    @dir + '/current'
  end
  
  def current_tournament_exists?
    File.exists?(current_tournament_path)
  end
end