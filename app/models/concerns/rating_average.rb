module RatingAverage
    extend ActiveSupport::Concern
   
    def rating_average(br)
        br.ratings.average("score")
    end
end