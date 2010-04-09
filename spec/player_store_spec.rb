require File.dirname(__FILE__) + '/spec_helper'

describe PlayerStore do
  subject do
    PlayerStore.new('spec/tmp/players')
  end
  
  before(:each) do
    FileUtils.rm_rf 'spec/tmp/players'
    subject.players.length.should == 0
  end
  
  describe "#store" do
    it "should add a player" do
      subject.store(mock(:name => 'foo'))
      subject.players.length.should == 1
    end
    
    it "should keep the player's name" do
      subject.store(mock(:name => 'foo'))
      subject.players.first.name.should == 'foo'
    end
  end
  
  describe "#clear" do
    context "when players exist" do
      before(:each) do
        subject.store(mock(:name => 'foo'))
        subject.players.length.should == 1
      end

      it "should result in zero players" do
        subject.clear
        subject.players.length.should == 0
      end
    end
  end
end
