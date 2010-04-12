require File.dirname(__FILE__) + '/../lib/player_upload'
require 'pathname'

describe PlayerUpload do
  def working_dir
    File.expand_path(File.dirname(__FILE__) + '/../spec/tmp/player_uploads')
  end
  
  before(:each) do
    FileUtils.rm_rf working_dir
    FileUtils.mkdir_p working_dir
  end
  
  def create_zip_file_in(path)
    Dir.chdir(zip_file_source) do
      `zip -r test.zip *`
      `mv test.zip #{path}`
    end
  end
  
  def with_zip
    path = working_dir + '/test.zip'
    create_zip_file_in(path)
    result = yield File.read(path)
    FileUtils.rm_rf(path)
    result
  end
  
  def self.zip_data(source)
    define_method(:zip_file_source) do
      Pathname.new(File.dirname(__FILE__) + "/data/player_uploads/#{source}")
    end
  end
  
  subject do
    with_zip { |data| PlayerUpload.new(data) }
  end
  
  describe "#unpack" do
    zip_data :valid

    it "unpacks the zip data to the current working directory" do
      Dir.chdir(working_dir) do
        subject.unpack
      end

      Dir.entries(working_dir).should == ['.', '..', 'test_player']
      Dir.entries(working_dir + '/test_player').should == ['.', '..', 'play']
    end
  end
  
  describe "#validation_error" do
    context "for a valid upload" do
      zip_data :valid

      it "returns nil" do
        subject.validation_error.should be_nil
      end
    end
    
    context "where there is no content in the zip" do
      zip_data :invalid_no_content

      it "returns the appropriate error message" do
        subject.validation_error.should =~ /empty/
      end
    end
    
    context "where there are two folders in the root" do
      zip_data :invalid_two_folders_in_root
      
      it "returns the appropriate error message" do
        subject.validation_error.should =~ /single/
      end
    end
    
    context "where there is no play command" do
      zip_data :invalid_no_play_cmd
      
      it "returns the appropriate error message" do
        subject.validation_error.should =~ /command/
      end
    end
    
    context "where the play command is not executable" do
      zip_data :invalid_play_cmd_not_executable
      
      it "returns the appropriate error message" do
        subject.validation_error.should =~ /executable/
      end
    end
  end
end