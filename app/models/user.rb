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
  has_many :beerclubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = Hash.new
    ratings.each do |r|
      styles[r.beer.style] = 0.0
    end

    styles.each_pair do |s|
      kpl = 0.0

      ratings.each do |r|
        if s.first == r.beer.style
          styles[s[0]] += r.score
          kpl += 1
        end
      end

      styles[s[0]] = styles[s[0]] / kpl
    end

    styles.sort_by { |key, value| value}.last.first
  end

  def favorite_brewery
    return nil if ratings.empty?

    brewery_hash = Hash.new
    ratings.each do |r|
      brewery_hash[r.beer.brewery] = 0.0
    end

    brewery_hash.each_pair do |b|
      kpl = 0.0

      ratings.each do |r|
        if b.first == r.beer.brewery
          brewery_hash[b[0]] += r.score
          kpl += 1
        end
      end

      brewery_hash[b[0]] = brewery_hash[b[0]] / kpl
    end

    brewery_hash.sort_by { |key, value| value}.last.first
  end
end
