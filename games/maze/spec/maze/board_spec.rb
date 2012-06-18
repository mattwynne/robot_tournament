require File.dirname(__FILE__) + '/../spec_helper'

describe Board do

  let(:players) do
    {
      'x' => mock('player', :name => 'player one'),
      '0' => mock('player', :name => 'player two')
    }
  end
  let(:game) { mock(Game).as_null_object }
  subject    { Board.new(game, players, double(:map)) }

  describe "#move!" do
  end
end
