module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    @avg = 0.0
    
    ratings.each do |rating|
      @avg += rating.score
    end

    return @avg / ratings.count
  end
end
