Given /^there is a player "([^\"]*)"$/ do |player_name|
  Given %{a file named "#{player_name}/play" with:}, %{
    """
    #!/usr/bin/env bash
    echo "ready"
    
    """
  }
  When "I zip up the folder and upload the data to '/players'"
  last_response.should be_ok
  in_current_dir do
    FileUtils.rm_rf player_name
  end
end