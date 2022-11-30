module RatingAverage
  extend ActiveSupport::Concern

  def rating_average(obj)
    return 0 if obj.ratings.average("score").nil?

    obj.ratings.average("score")
  end
end
