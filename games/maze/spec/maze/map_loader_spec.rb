require File.dirname(__FILE__) + '/../spec_helper'

describe MapLoader do
  let(:path) { "map_path" }
  let(:map_data) { %(***********
*...___...*
..........*
*...*.....*
*...*.....*
*******F***
Player 1: 1,4
Player 2: 2,4) }
  before do
    File.stub(:read => map_data)
  end
  it "loads a map from a file" do
    File.should_receive(:read).with(path).and_return(map_data)
    MapLoader.new(path)
  end

  it "reads the blueprint ok" do
    MapLoader.new(path).blueprint.should == %(***********
*...___...*
..........*
*...*.....*
*...*.....*
*******F***)
  end

  it "reads the player coordinates" do
    MapLoader.new(path).players_start[0].should == [1,4]
    MapLoader.new(path).players_start[1].should == [2,4]
  end
end
