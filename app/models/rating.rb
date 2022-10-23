class Rating < ApplicationRecord
    belongs_to :beer

    def to_s
        puts "#{self.beer.name} #{self.score}"
    end

end
