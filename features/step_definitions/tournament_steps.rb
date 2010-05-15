require 'chronic_duration'
require 'spec/expectations'
require 'cucumber/web/tableish'

When /^(?:I create )?a(?: new)? Tournament "([^\"]*)" with the following attributes:$/ do |name, table|
  attributes = table.rows_hash
  attributes["name"] = name
  TournamentStore.new.create(attributes).start!
end

Given /^there is a tournament$/ do
  tournament = TournamentStore.new.create(:name => "Test Tournament", :rounds => 3, :duration => 7)
  tournament.start!
end

Then /^I should see that the Tournament "([^\"]*)" is in progress$/ do |name|
  page.should have_content(%{Running Tournament: "#{name}"})
end

Then /^I should see that the first Round will begin in less than 10 minutes$/ do
  duration = page.body.scan(/Next round begins in (.*)/).flatten.first
  ChronicDuration.parse(duration).should be < (10 * 60)
end

Then /^I should see that no players are registered for the Round$/ do
  page.should have_content "no players"
end

Then /^I should see that "(.*)" is (?:the winner|winning)$/ do |name|
  winner = find("//*[@id='winner']")
  winner.should_not be_nil
  winner.text.should == name
end

When /^the engine is kicked$/ do
  tournament.kick
end

Then /^I should see that the tournament has finished$/ do
  page.should have_content %{Finished Tournament: "#{tournament.name}"}
end

Then /^I should see that 2 rounds were played$/ do
  page.all("//*[@class='finished round']").length.should == 2
end

Then /^I should see that 2 matches were played in each round$/ do
  finished_rounds = page.all("//*[@class='finished round']")
  finished_rounds.length.should == 2
  finished_rounds.each do |round|
    round.all("//*[@class='match']").length.should == 2
  end
end

When /^the (?:first|next) round has been played$/ do
  secs = tournament.seconds_until_next_round + 1
  When "#{secs} seconds pass"
  tournament.kick
end

Then /^I should see that the first round has finished$/ do
  page.all("//*[@class='finished round']").length.should == 1
end

Then /^I should see that the league table looks like:$/ do |table|
  html_table = tableish("table#league tr", "td,th")
  # downcase col headers to match ruby
  html_table[0] = html_table[0].map{ |cell| cell.downcase } 
  table.diff!(html_table)
end

Then /^I should see that there (?:is|are) (\d+) of (\d+) rounds still to be played$/ do |remaining, total|
  total = total.to_i
  remaining = remaining.to_i
  next_round = total - remaining + 1
  page.should have_content("Round #{next_round} (of #{total})")
end

Then /^I should see that the lead is tied between "([^\"]*)" and "([^\"]*)"$/ do |player1, player2|
  page.should have_content("#{player1} and #{player2} are tied")
end