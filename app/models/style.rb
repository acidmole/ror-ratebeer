class Style < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  include RatingAverage

  def average_rating
    rating_average(self)
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by { |b| b.average_rating }.reverse.take(n)
  end
end
