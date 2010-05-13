require File.dirname(__FILE__) + '/../spec_helper'

describe PlayerStore do
  subject do
    PlayerStore.new('spec/tmp/players')
  end
  
  before(:each) do
    FileUtils.rm_rf 'spec/tmp/players'
    subject.players.length.should == 0
  end
  
  describe "#players" do
    let(:foo) { mock(:player_name => 'foo') }
    let(:bar) { mock(:player_name => 'bar') }
    
    it "returns a player object for each folder in the store" do
      foo.stub(:unpack) do
        FileUtils.mkdir 'foo'
      end
      
      bar.stub(:unpack) do
        FileUtils.mkdir 'bar'
      end
      
      [foo, bar].each { |u| subject.store(u) }

      subject.players.length.should == 2
      subject.players.find { |p| p.name == "foo" }.should be_a(Player)
      subject.players.find { |p| p.name == "bar" }.should be_a(Player)
    end
  end
  
  describe "#store" do
    let(:upload) { mock(:player_name => 'foo') }
    
    before(:each) do
      upload.should_receive(:unpack) do
        FileUtils.mkdir_p('foo')
      end
    end
    
    it "unpacks the upload" do
      subject.store(upload)
    end
    
    it "returns an instance of Player that represents the newly stored upload" do
      result = subject.store(upload)
      result.name.should == 'foo'
    end
  end
  
  describe "#clear" do
    context "when players exist" do
      let(:upload) { mock(:player_name => 'foo') }

      before(:each) do
        upload.should_receive(:unpack) do
          FileUtils.mkdir('foo')
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
