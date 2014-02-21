require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"Iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
      }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  def rating_data
    create_rating(beer:"Iso 3", score:"10")
    create_rating(beer:"Karhu", score:"15")
  end

  it "when new ratings done they exist on ratings page" do
    rating_data
    visit ratings_path

    expect(page).to have_content "Ratings total: #{Rating.count}"
    expect(page).to have_content "Iso 3"
    expect(page).to have_content "Karhu"
  end

  it "when new ratings done they exist on user page" do
    rating_data
    expect(page).to have_content "has made #{Rating.count} ratings"
    expect(page).to have_content "Iso 3"
    expect(page).to have_content "Karhu"
  end

  it "after creation destroy, removes from db" do
    create_rating(beer:"Iso 3", score:"10")

    click_link "Destroy"

    expect(Rating.count).to eq(0)
  end

  it "user has favorite style and brewery" do
    rating_data
    expect(page).to have_content "favorite style: Lager"
    expect(page).to have_content "favorite brewery: Koff"
  end
end
