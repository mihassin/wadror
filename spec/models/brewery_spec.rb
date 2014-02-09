require 'spec_helper'

describe Brewery do
  it "without a name is not valid" do
    brewery = Brewery.create year:1674

    brewery.should_not be_valid
  end

  it "has the name and year set correctly and is saved to db" do
    brewery = Brewery.create name:"Schlenkerla", year:1674

    brewery.name.should == "Schlenkerla"
    brewery.year.should == 1674
    brewery.should be_valid
  end

  describe "when initialized with name Schlenkerla and year 1674" do
    subject{ Brewery.create name:"Schlenkerla", year:1674 }

    it { should be_valid }
    its(:name) { should eq("Schlenkerla") }
    its(:year) { should be(1674) }
  end
end
