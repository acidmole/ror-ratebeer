class Beer < ApplicationRecord
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  include RatingAverage

  validates :name, presence: true

  def average
    return 0 if ratings.empty?

    ratings.map{ :score }.sum / ratings.count.to_f
  end

  def average_rating
    rating_average(self)
  end

  def to_s
    "#{name} (#{brewery.name})"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by { |b| b.average_rating }.reverse.take(n)
  end

end
