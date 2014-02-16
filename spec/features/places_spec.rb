require 'spec_helper'

describe "Places" do
  def create_fake_places(places)
    arr = Array.new
    unless places.nil?
      places.each do |place|
        arr.push( Place.new(id: 1, name: place) )
      end
    end
    return arr
  end

  def try_search(city,place)
    BeermappingApi.stub(:places_in).with(city).and_return( create_fake_places(place) )
    visit places_path
    fill_in('city', with: city)
    click_button "Search"
  end

  it "if one is returned by the API, it is shown at the page" do
    try_search("kumpula", ["Oljenkorsi"])
    expect(page).to have_content "Oljenkorsi"
  end

  it "if nothing is returned by the API, page doesn't contain any places" do
    try_search("vantaa", nil)
    expect(page).to have_content "No places in vantaa"
  end

  it "if many is returned by the API, it is shown at the page" do
    try_search("helsinki", ["asd","das", "sad"])
    expect(page).to have_content "asd"
    expect(page).to have_content "das"
    expect(page).to have_content "sad"
  end
end
