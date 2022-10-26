class Brewery < ApplicationRecord
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	include RatingAverage

	def average_rating
		rating_average(self)
	end
end