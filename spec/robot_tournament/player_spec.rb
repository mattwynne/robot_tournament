require File.dirname(__FILE__) + '/../spec_helper'

describe Player do
  before(:each) do
    FileUtils.mkdir_p('spec/tmp/player')
    File.open('spec/tmp/player/move', 'w') do |io|
      io.puts "#!/usr/bin/env ruby"
      io.puts "puts 'hello'"
    end
  end
  
  after(:each) do
    FileUtils.rm_rf('spec/tmp/player')
  end
  
  subject do
    Player.new('spec/tmp/player')
  end
  
  describe "#name" do
    it "is named after the folder" do
      subject.name.should == 'player'
    end
  end
  
  describe "#move" do
    it "runs the executable 'move' and returns the output" do
      subject.move.strip.should == "hello"
    end
  end
end
