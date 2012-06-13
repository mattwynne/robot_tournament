require File.dirname(__FILE__) + '/../spec_helper'

describe Map do
  it 'places players in their starting positions' do
    blueprint = "*****\n" +
                "*...*\n" +
                "*...*\n" +
                "**F**"
    player1_start = [1,1]
    player2_start = [1,3]

    map = Map.new(blueprint, player1_start, player2_start)

    map.state.should == "*****\n" +
                        "*1.2*\n" +
                        "*...*\n" +
                        "**F**"
  end
end
