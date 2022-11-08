class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }, format: { with: /[A-Z]{1,}/, message: "must be one upper case character" }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def average_rating
    rating_average(self)
  end

  def favorite_beer
    return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    Rating.connection.select_all("SELECT AVG(ratings.score), beers.style 
    FROM ratings 
    LEFT JOIN beers ON beers.id = ratings.beer_id
    LEFT JOIN users ON users.id = ratings.user_id 
    WHERE users.id = #{id}
    GROUP BY beers.style, ratings.score
    ORDER BY AVG(ratings.score) DESC")[0]["style"]
  end

  def favorite_brewery
    return nil if ratings.empty?

    Rating.connection.select_all("SELECT AVG(ratings.score), breweries.name
    FROM ratings
    LEFT JOIN beers ON beers.id = ratings.beer_id
    LEFT JOIN breweries ON breweries.id = beers.brewery_id
    LEFT JOIN users ON users.id = ratings.user_id 
    WHERE users.id = #{id}
    GROUP BY breweries.name
    ORDER BY AVG(ratings.score) DESC")[0]["name"]
  end
end
