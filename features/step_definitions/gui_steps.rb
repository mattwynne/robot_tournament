When "I go to the homepage" do
  visit "/"
end

Then /^I should see the following players listed:$/ do |table|
  table.raw.each do |row|
    page.should have_content(row.to_s)
  end
end

When /^I follow "([^"]*)"$/ do |link_text|
  click_link link_text
end

Then /^I should see that there are (\d+) results$/ do |num|
  page.all(:css, ".match").length.should == num.to_i
end
