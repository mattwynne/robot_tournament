require File.dirname(__FILE__) + '/../../lib/web_ui/player_upload_handler'

describe PlayerUploadHandler do
  
  let(:player_upload) { mock('player_upload', :valid? => true) }
  let(:raw_data)      { mock('raw_data') }
  let(:player)        { mock('player', :name => 'foo' )}
  let(:player_store)  { mock('player_store', :store => player) }
  
  subject { PlayerUploadHandler.new(raw_data) }
  
  before(:each) do
    PlayerUpload.stub!(:new).and_return(player_upload)
    PlayerStore.stub!(:new).and_return(player_store)
  end
  
  describe "#process" do
    it "validates the upload" do
      player_upload.should_receive(:valid?)
      subject.process
    end
    
    context "if there were no validation errors" do
      before(:each) do
        player_upload.stub(:valid?).and_return(true)
      end

      it "returns a success message" do
        subject.process.should =~ /OK/
        subject.process.should =~ /foo/
      end
      
      it "stores the player" do
        player_store.should_receive(:store).with(player_upload)
        subject.process
      end
    end
    
    
    it "raises any validation error" do
      player_upload.stub(:valid?).and_return(false)
      player_upload.stub(:validation_error_message).and_return("foo")
      lambda { subject.process }.should raise_error(ValidationError) do |error| 
        error.message.should =~ /foo/
      end
    end
  end
end
