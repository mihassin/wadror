require 'spec_helper'

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_beer_with_brewery_and_rating(score, brewery, user)
  brewery = FactoryGirl.create(:brewery, name:brewery)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_brewery_and_ratings(*scores, brewery ,user)
  scores.each do |score|
    create_beer_with_brewery_and_rating(score, brewery, user)
  end
end

def create_beer_with_style_and_rating(score, style, user)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_style_and_ratings(*scores, style ,user)
  scores.each do |score|
    create_beer_with_style_and_rating(score, style, user)
  end
end

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is saved with a proper password" do
    user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"

    expect(user.valid?).to be(true)
    expect(User.count).to eq(1)
  end

  it "with a proper password and two ratings, has the correct average rating" do
    user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"
    rating = Rating.new score:10
    rating2 = Rating.new score:20

    user.ratings << rating
    user.ratings << rating2

    expect(user.ratings.count).to eq(2)
    expect(user.average_rating).to eq(15)
  end

  it "with too short password won't be saved" do
    user = User.create username:"Pekka", password:"Sec", password_confirmation:"Sec"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "password containing only letters won't be saved" do
    user = User.create username:"Pekka", password:"Secretpassword", password_confirmation:"Secretpassword"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
     expect(user).to be_valid
     expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the favorite_beer" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with the highest if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user)}

    it "has method for determining the favorite_style" do
      user.should respond_to :favorite_style
    end

    it "without ratings doesn't have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with the highest average_rating" do
      create_beers_with_ratings(1, 2, 3, 4, user)
      create_beers_with_style_and_ratings(10, 11, 12, "Porter", user)
      create_beer_with_style_and_rating(50, "Pale ale", user)
      expect(user.favorite_style).to eq("Pale ale")
    end
  end

  describe "style" do
    let(:user){ FactoryGirl.create(:user)}

    it "of beer is correct" do
      beer = create_beer_with_style_and_rating(10, "Pale ale", user)
      expect(user.favorite_beer.style).to eq("Pale ale")
    end

    it "of multiple beers is correct" do
      create_beers_with_style_and_ratings(10, 11, 12, "Pale ale", user)

      user.ratings.each do |r|
        expect(r.beer.style).to eq("Pale ale")
      end
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user)}

    it "has method for determining the favorite_style" do
      user.should respond_to :favorite_style
    end

    it "without ratings doesn't have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_brewery_and_rating(10, "a",user)
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with the highest average_rating" do
      create_beers_with_ratings(1, 2, 3, 4, user)
      create_beers_with_brewery_and_ratings(10, 11, 12, "Koff", user)
      expect(user.favorite_brewery.name).to eq("Koff")
    end
  end
end
