# TODO: move this somewhere so other games can share it
Given /^a player "([^\"]*)" who moves like this:$/ do |name, move_file_content|
  create_dir(name)
  create_file("#{name}/move", move_file_content)
  run("chmod +x #{name}/move")
  @last_stderr.should be_empty
end

When /^a game is played between "([^\"]*)" and "([^\"]*)"$/ do |player_1, player_2|
  game_path = File.expand_path(File.dirname(__FILE__) + "/../../bin/maze")
  in_current_dir do
    player_1_path = File.expand_path(player_1)
    player_2_path = File.expand_path(player_2)
    run("#{game_path} #{player_1_path} #{player_2_path} #{@opts}")
  end
end

Given /^the maximum seconds allowed for a move is "(.*)"$/ do |timeout|
  @opts = "#{@opts} --timeout #{timeout}"
end

Given /^map "([^"]*)" is selected$/ do |map_name|
  @opts = "#{@opts} --map #{map_name}"
end

Given /^the maximum number of moves allowed is (\d+)$/ do |max|
  @opts = "#{@opts} --maxmoves #{max}"
end
