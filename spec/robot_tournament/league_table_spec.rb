require 'spec_helper'
require 'robot_tournament/league_table'

describe LeagueTable do
  context "with a single leader" do
    subject do
      LeagueTable.new([
        { "player" => "leader", "points" => 10},
        { "player" => "loser", "points" => 3}
      ])
    end
    
    describe "#leaders" do
      it "contains the name of the leader" do
        subject.leaders.should == ["leader"]
      end
    end
  end
  
  context "with multiple leaders" do
    subject do
      LeagueTable.new([
        { "player" => "leader1", "points" => 10},
        { "player" => "leader2", "points" => 10},
        { "player" => "loser", "points" => 3}
      ])
    end
    
    describe "#leaders" do
      it "contains the name of the leader" do
        subject.leaders.should == ["leader1", "leader2"]
      end
    end
  end
end
