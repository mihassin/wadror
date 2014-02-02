class Brewery < ActiveRecord::Base
  include RatingAverage

  def future_year
    if year > Date.today.year
      errors.add(:year, "seems to be incorrect")
    end
  end

  validates :year, numericality: { greater_than_or_equal_to: 1042, only_integer: true }
  validates :name, presence: true
  validate :future_year

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{ratings.count}"
  end

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end
end
