require File.dirname(__FILE__) + '/../lib/player_upload'
require 'pathname'

describe PlayerUpload do
  def working_dir
    result = File.expand_path(File.dirname(__FILE__) + '/../spec/tmp/player_uploads')
    raise(result) unless result[0..0] == "/"
    result
  end
  
  before(:each) do
    FileUtils.rm_rf working_dir
    FileUtils.mkdir_p working_dir
    subject # because lazy eval screws up paths
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
    result = yield(File.read(path))
    FileUtils.rm_rf(path)
    result
  end
  
  def self.zip_data(source)
    path = File.expand_path(
      File.dirname(__FILE__) + 
      "/data/player_uploads/#{source}")
      
    define_method(:zip_file_source) do
      Pathname.new(path)
    end
  end
  
  subject do
    with_zip { |data| PlayerUpload.new(data) }
  end
  
  describe "#unpack" do
    context "for an invalid uplaod" do
      zip_data :invalid_no_folder_in_root
      
      it "raises an exception" do
        lambda { subject.unpack }.should raise_error(ValidationError)
      end
    end
    
    context "for a valid upload" do
      zip_data :valid

      it "unpacks the zip data to the current working directory" do
        Dir.chdir(working_dir) do
          subject.unpack
        end

        Dir.entries(working_dir).should == ['.', '..', 'test_player']
        Dir.entries(working_dir + '/test_player').should == ['.', '..', 'play']
      end
    
      it "replaces any existing upload" do
        Dir.chdir(working_dir) do
          FileUtils.mkdir('test_player')
          FileUtils.touch('test_player/foo')
        end
        
        File.exist?(working_dir + '/test_player/foo').should be_true
        
        Dir.chdir(working_dir) do
          subject.unpack
        end
      
        File.exist?(working_dir + '/test_player/foo').should be_false
      end
    end
  end
  
  describe "#valid?" do
    context "for a valid upload" do
      zip_data :valid
      
      it { subject.should be_valid }

      it "returns nil" do
        subject.validation_error_message.should be_nil
      end
    end
    
    context "where there are no folders in the root" do
      zip_data :invalid_no_folder_in_root

      it "returns the appropriate error message" do
        subject.validation_error_message.should =~ /single/
      end
    end
    
    context "where there are two folders in the root" do
      zip_data :invalid_two_folders_in_root
      
      it "returns the appropriate error message" do
        subject.validation_error_message.should =~ /single/
      end
    end
    
    context "where there is no play command" do
      zip_data :invalid_no_play_cmd
      
      it "returns the appropriate error message" do
        subject.validation_error_message.should =~ /command/
      end
    end
  end
end