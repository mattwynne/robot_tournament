require 'spec_helper'

describe RoundRunner do
  describe "#start!" do
    context "with several players" do
      let(:game)     { mock(Game) }
      let(:observer) { mock(Round, :results! => nil, :league_table! => nil) }
      let(:player1)  { mock(:name => 'player1') }
      let(:player2)  { mock(:name => 'player2') }
      let(:player_store) do
        mock(PlayerStore, :players => [player1, player2])
      end
    
      subject do
        RoundRunner.new(player_store, game, observer)
      end
    
      it "tells the game to play a match between each combination of the players" do
        game.should_receive(:play).with(player1, player2).exactly(:once)
        game.should_receive(:play).with(player2, player1).exactly(:once)
        subject.start!
      end
      
      context "when results come in" do
        before(:each) do
          game.stub(:play).
            with(player1, player2).
            and_return [player1, "output as player1 wins"]
          game.stub(:play).
            with(player2, player1).
            and_return [nil, "output as draw happens"]
        end
        
        it "posts a league table to the observer" do
          expected_table = [
            { "player" => "player1", "points" => 4 },
            { "player" => "player2", "points" => 1 }
          ]
          observer.should_receive(:league_table!).with(expected_table)
          subject.start!
        end
        
        it "posts the individual results to the observer" do
          expected_results = [
            { 
              "player1" => "player1", 
              "player2" => "player2", 
              "winner"  => "player1", 
              "output"  => "output as player1 wins" 
            },
            { 
              "player1" => "player2", 
              "player2" => "player1", 
              "winner"  => nil, 
              "output"  => "output as draw happens" 
            }
          ]
          observer.should_receive(:results!).with(expected_results)
          subject.start!
        end
      end

      context "when one player loses every time" do
        before(:each) do
          game.stub(:play).
            with(player1, player2).
            and_return [player1, ""]
          game.stub(:play).
            with(player2, player1).
            and_return [player1, ""]
        end
        
        it "posts a league table containing all players, including the loser" do
          expected_table = [
            { "player" => "player1", "points" => 6 },
            { "player" => "player2", "points" => 0 }
          ]
          observer.should_receive(:league_table!).with(expected_table)
          subject.start!
        end
        
      end
    end
  end
end
