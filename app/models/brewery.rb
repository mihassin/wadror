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

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order[0 .. 4]
  end

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
