require File.dirname(__FILE__) + '/../spec_helper'

describe Map do
  context "loading from file" do
    let(:blueprint) { "****" }
    let(:loader) { double(:blueprint => blueprint, :players_start => [[1,1],[2,2]]) }
    let(:path) { double }
    before do
      MapLoader.stub(:new => loader)
    end

    it "delegates to MapLoader" do
      MapLoader.should_receive(:new).with(path).and_return(loader)
      Map.load(path)
    end

    it "queries MapLoader for vitals" do
      Map.should_receive(:new).with(blueprint, [1, 1], [2, 2])
      Map.load(path)
    end
  end

  context "creating from string" do

    let(:blueprint) {
      "*****\n" +
      "*...*\n" +
      "*...*\n" +
      "**F**"
    }
    let(:map) { Map.new(blueprint, [1,2], [3,1]) }

    it 'places players in their starting positions' do
      map.state.should == "*****\n" +
        "*..2*\n" +
        "*1..*\n" +
        "**F**"
    end

    it 'allows a player to move east to a valid space' do
      map.move('1', 'E')

      map.state.should == "*****\n" +
        "*..2*\n" +
        "*.1.*\n" +
        "**F**"
    end

    it 'allows a player to move north to a valid space' do
      map.move('1', 'N')

      map.state.should == "*****\n" +
                          "*1.2*\n" +
                          "*...*\n" +
                          "**F**"
    end

    it 'allows a player to move south to a valid space' do
      map.move('2', 'S')

      map.state.should == "*****\n" +
                          "*...*\n" +
                          "*1.2*\n" +
                          "**F**"
    end

    it 'allows a player to move west to a valid space' do
      map.move('2', 'W')

      map.state.should == "*****\n" +
                          "*.2.*\n" +
                          "*1..*\n" +
                          "**F**"
    end

    it 'does not move a player who walks into a wall' do
      map.move('1', 'S')

      map.state.should == "*****\n" +
                          "*..2*\n" +
                          "*1..*\n" +
                          "**F**"
    end

    it 'does not allow a player to make an illegal move' do
      expect { map.move('1', 'foo') }.to raise_error(Map::IllegalMove)
    end

    it 'does not allow player to walk into another player' do
      map.move('1', 'N')
      map.move('2', 'W')

      expect { map.move('1', 'E') }.to raise_error(Map::PlayerCollision)
    end

    it 'reports no winner if no one has one' do
      map.winner.should be_nil
    end

    it 'will report a winner' do
      map.move('2', 'W')
      map.move('2', 'S')
      map.move('2', 'S')
      map.winner.should == '2'
    end

    context 'a map with ice' do
      let(:blueprint) {
        "*************\n" +
        "*.........._*\n" +
        "*._........_*\n" +
        "*._........_*\n" +
        "*.....____..*\n" +
        "*...........*\n" +
        "**F**********"
      }
      let(:map) { Map.new(blueprint, [1,1], [11,5]) }

      it 'moves you another step in the same direction' do
        map.move('1', 'S')
        map.move('1', 'E')
        map.state.should == "*************\n" +
                            "*.........._*\n" +
                            "*._1......._*\n" +
                            "*._........_*\n" +
                            "*.....____..*\n" +
                            "*..........2*\n" +
                            "**F**********"

      end

      it 'moves you along a whole line of ice' do
        map.move('1', 'E')
        map.move('1', 'S')

        map.state.should == "*************\n" +
                            "*.........._*\n" +
                            "*._........_*\n" +
                            "*._........_*\n" +
                            "*.1...____..*\n" +
                            "*..........2*\n" +
                            "**F**********"
      end

      it 'moves you up to a wall' do
        map.move('2', 'N')
        map.move('2', 'N')

        map.state.should == "*************\n" +
                            "*1.........2*\n" +
                            "*._........_*\n" +
                            "*._........_*\n" +
                            "*.....____..*\n" +
                            "*...........*\n" +
                            "**F**********"
      end

      it 'will slide you on to another player, beware!' do
        map.move('2', 'N')
        map.move('2', 'W')
        map.move('1', 'E')
        map.move('1', 'S')
        map.move('1', 'E')
        map.move('1', 'E')
        map.move('1', 'E')
        expect { map.move('1', 'E') }.to raise_error(Map::PlayerCollision)
      end
    end
  end
end
