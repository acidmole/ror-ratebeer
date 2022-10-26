class Beer < ApplicationRecord
	belongs_to :brewery
	has_many :ratings, dependent: :destroy

	include RatingAverage

	def average_rating
		rating_average(self)
	end

	def to_s
        "#{self.name} (#{self.brewery.name})"
    end
end
