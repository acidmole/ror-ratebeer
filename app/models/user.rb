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

    Rating.connection.select_all("SELECT AVG(ratings.score), styles.name
    FROM ratings
    LEFT JOIN beers ON beers.id = ratings.beer_id
    LEFT JOIN styles ON styles.id = beers.style_id
    WHERE ratings.user_id = #{id}
    GROUP BY styles.name
    ORDER BY AVG(ratings.score) DESC")[0]["name"]
  end

  def favorite_brewery
    return nil if ratings.empty?

    Rating.connection.select_all("SELECT AVG(ratings.score), breweries.name
    FROM ratings
    LEFT JOIN beers ON beers.id = ratings.beer_id
    LEFT JOIN breweries ON breweries.id = beers.brewery_id
    WHERE ratings.user_id = #{id}
    GROUP BY breweries.name
    ORDER BY AVG(ratings.score) DESC")[0]["name"]
  end

  def self.most_active(n)
    sorted_by_rating_count_in_desc_order = User.all.sort_by { |u| u.ratings.count }.reverse.take(n)
  end

end
