class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040, only_integer: true }
  validate :year_cannot_be_in_the_future

  def average_rating
    rating_average(self)
  end

  def year_cannot_be_in_the_future
    return unless year > Date.today.year

    errors.add(:year, "can't be in the future")
  end
end
