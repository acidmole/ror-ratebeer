module RatingAverage
  extend ActiveSupport::Concern

  def rating_average(obj)
    obj.ratings.average("score")
  end
end
