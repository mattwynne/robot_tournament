When /^I zip up the folder and upload the data to '\/players'$/ do
  in_current_dir do
    Dir['.'].length.should == 1
    the_folder = Dir['.'].first
    `zip -r #{the_folder}.zip #{the_folder}`
    File.open("#{the_folder}.zip") do |io|
      post "/players", {}, {'rack.input' => io}
    end
  end
end

Then /^the response should be 200 OK$/ do
  last_response.should be_ok
end

Then /^I should see "([^\"]*)" in the response$/ do |expected_text|
  last_response.body.should =~ /#{expected_text}/
end