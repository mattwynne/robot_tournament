When "I go to the homepage" do
  visit "/"
end


Then /^I should see the following players listed:$/ do |table|
  table.raw.each do |row|
    last_response.body.should =~ /#{row.to_s}/
  end
end