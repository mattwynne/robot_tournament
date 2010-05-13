require 'spec_helper'
require 'robot_tournament/web_ui'

describe PlayerUploadHandler do
  
  let(:raw_data)         { mock('raw_data') }
  let(:player_upload)    { mock(PlayerUpload, :valid? => true) }
  let(:player)           { mock(Player, :name => 'foo' )}
  let(:tournament)       { mock(Tournament, :store_player_upload => player) }
  let(:tournament_store) { mock(TournamentStore, :current => tournament) }
  
  subject { PlayerUploadHandler.new(raw_data) }
  
  before(:each) do
    PlayerUpload.stub!(:new).and_return(player_upload)
    TournamentStore.stub!(:new).and_return(tournament_store)
  end
  
  describe "#process" do
    it "validates the upload" do
      player_upload.should_receive(:valid?)
      subject.process
    end
    
    context "if there is no current tournament" do
      before(:each) do
        TournamentStore.stub(:new).and_return(mock(TournamentStore, :current => nil))
      end
      
      it "raises an exception" do
        expect { subject.process }.to raise_error(NoCurrentTournament)
      end
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
        tournament.should_receive(:store_player_upload).with(player_upload)
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
