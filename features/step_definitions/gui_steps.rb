When "I go to the homepage" do
  visit "/"
end

Then /^I should see the following players listed:$/ do |table|
  table.raw.each do |row|
    page.should have_content(row.to_s)
  end
end