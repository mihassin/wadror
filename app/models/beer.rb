class Beer < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user  

  def to_s
    return "#{brewery.name}: #{name}"
  end
end
