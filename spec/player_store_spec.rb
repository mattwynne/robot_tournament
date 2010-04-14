require File.dirname(__FILE__) + '/../lib/player_store'

describe PlayerStore do
  subject do
    PlayerStore.new('spec/tmp/players')
  end
  
  before(:each) do
    FileUtils.rm_rf 'spec/tmp/players'
    subject.players.length.should == 0
  end
  
  describe "#players" do
    it "returns a player object for each folder in the store" do
      @foo = mock('PlayerUpload')
      @foo.stub(:unpack) do
        FileUtils.mkdir 'foo'
      end
      
      @bar = mock('PlayerUpload')
      @bar.stub(:unpack) do
        FileUtils.mkdir 'bar'
      end
      
      [@foo, @bar].each { |u| subject.store(u) }

      subject.players.length.should == 2
      subject.players.find { |p| p.name == "foo" }.should be_a(Player)
      subject.players.find { |p| p.name == "bar" }.should be_a(Player)
    end
  end
  
  describe "#store" do
    before(:each) do
      @upload = mock
      @upload.should_receive(:unpack)
    end
    
    it "unpacks the upload" do
      subject.store(@upload)
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
