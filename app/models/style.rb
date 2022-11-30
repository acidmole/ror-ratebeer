class Style < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  include RatingAverage

  def average_rating
    rating_average(self)
  end

  def self.top(amount)
    Style.all.sort_by(&:average_rating).reverse.take(amount)
  end
end
