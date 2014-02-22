class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
  validates :password, length: { minimum: 4 }
  validates_format_of :password, with: /[A-Z]/
  validates_format_of :password, with: /[0-9]/

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def self.most_active(n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |b| -(b.ratings.count||0) }
    sorted_by_rating_in_desc_order.take(n)
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score}.last.beer
  end

  def favorite_style
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def rating_average(category, item)
    ratings_of_item = ratings.select{ |r|r.beer.send(category)==item }
    return 0 if ratings_of_item.empty?
    ratings_of_item.inject(0.0){ |sum ,r| sum+r.score } / ratings_of_item.count
  end

  def favorite(category)
    return nil if ratings.empty?
    rating_pairs = rated(category).inject([]) do |pairs, item|
      pairs << [item, rating_average(category, item)]
    end
    rating_pairs.sort_by { |s| s.last }.last.first
  end
end
