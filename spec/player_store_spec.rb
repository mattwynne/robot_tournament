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
    before(:each) do
      @upload = mock
      @upload.should_receive(:unpack) do
        FileUtils.mkdir('test-player-name')
      end
    end
    it "should unpack the upload" do
      subject.store(@upload)
      subject.players.length.should == 1
    end
    
    it "should keep the player's name" do
      subject.store(@upload)
      subject.players.first.name.should == 'test-player-name'
    end
  end
  
  describe "#clear" do
    context "when players exist" do
      before(:each) do
        upload = mock
        upload.should_receive(:unpack) do
          FileUtils.mkdir('test-player-name')
        end
        subject.store(upload)
        subject.players.length.should == 1
      end

      it "should result in zero players" do
        subject.clear
        subject.players.length.should == 0
      end
    end
  end
end
