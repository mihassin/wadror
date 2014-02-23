require 'spec_helper'
include OwnTestHelper

describe 'Beer' do

  before :each do
    FactoryGirl.create :user
    FactoryGirl.create :brewery
    FactoryGirl.create :style
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "has valid name" do
    visit new_beer_path
    fill_in('beer_name', with:"Koff")
    select('Lager', from:'beer[style_id]')
    select('anonymous', from:"beer[brewery_id]")
    click_button('Create Beer')

    expect(current_path).to eq(beers_path)
    expect(Beer.count).to eq(1)
    expect(page).to have_content "Beers"
  end

  it "has invalid name" do
    visit new_beer_path
    click_button('Create Beer')

    expect(current_path).to eq(beers_path)
    expect(page).to have_content "error"
    expect(Beer.count).to eq(0)
  end
end
