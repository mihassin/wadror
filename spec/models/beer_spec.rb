require 'spec_helper'

describe Beer do
  before :each do
    @style = FactoryGirl.create :style
  end

  it "with proper name and style will be saved" do
    beer = Beer.create name:"Koff", style: @style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "won't be saved without name" do
    beer = Beer.create style: @style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "won't be saved without style" do
    beer = Beer.create name:"Koff"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
