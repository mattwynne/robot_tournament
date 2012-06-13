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
    context "when the board has a completed line on it" do
      it "should report the winner" do
        game.should_receive(:winner).with('player one', 'xxx------')
        [0,1,2].each { |move| subject.move!(move, 'x') }
      end
    end

    context "when the board is full but there is no winner" do
      it "reports a draw" do
        game.should_receive(:draw).with('x0xx000xx')
        # xyx
        # xyy
        # yxx
        [0,2,3,7,8].each do |move|
          subject.move!(move, 'x')
        end
        [1,4,5,6].each do |move|
          subject.move!(move, '0')
        end
      end
    end

    context "when a player tries to update a square that is already occupied" do
      it "signals that the player has fouled" do
        game.should_receive(:foul).with('x','attempted to play on an already-taken space')
        subject.move!(0, 'x')
        subject.move!(0, 'x')
      end

      it "signals that the other player has won" do
        game.should_receive(:winner).with('player two', 'x--------')
        subject.move!(0, 'x')
        subject.move!(0, 'x')
      end
    end
  end
end
