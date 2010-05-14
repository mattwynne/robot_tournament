Given /^a player "(.*)" who always says "(.*)"$/ do |player_name, move|
  Given %{a file named "#{player_name}/move" with:}, <<-MOVE
#!/usr/bin/env bash
echo "#{move}"
MOVE
  When %{I zip up the folder and upload the data to "/players"}
  page.driver.response.should be_ok
  in_current_dir do
    FileUtils.rm_rf player_name
  end
end

Given /^there is a player "([^\"]*)"$/ do |player_name|
  Given %{a player "#{player_name}" who always says "ready"}
end