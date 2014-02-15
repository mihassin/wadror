class Beer < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name, :style

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  def to_s
    return "#{brewery.name}: #{name}"
  end
end
