Given /^there is a player "([^\"]*)"$/ do |player_name|
  Given %{a file named "#{player_name}/move" with:}, %{
    """
    #!/usr/bin/env bash
    echo "ready"
    
    """
  }
  When "I zip up the folder and upload the data to '/players'"
end