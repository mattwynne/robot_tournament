Before('@rack_test') do
  @old_value = Sinatra::Application.raise_errors
  Sinatra::Application.raise_errors = false
end
After('@rack_test') do
  Sinatra::Application.raise_errors = @old_value
end

When /^I zip up the folder and upload the data to "\/players"$/ do
  in_current_dir do
    Dir['.'].length.should == 1
    the_folder = Dir['.'].first
    `zip -r #{the_folder}.zip #{the_folder}`
    File.open("#{the_folder}.zip") do |io|
      page.driver.post "/players", {}, {'rack.input' => io}
    end
    FileUtils.rm_rf("#{the_folder}.zip")
  end
end

Then /^the response should be 200 OK$/ do
  page.driver.response.should be_ok
end

Then /^the response should be 500 NOT OK$/ do
  page.driver.response.should_not be_ok
  # pending # express the regexp above with the code you wish you had
end


Then /^I should see "([^\"]*)" in the response$/ do |expected_text|
  page.driver.response.body.should =~ /#{expected_text}/
end