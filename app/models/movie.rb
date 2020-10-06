class Movie < ApplicationRecord
  before_save :set_slug

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user 
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  validates :released_on, :duration, presence: true
  validates :title, presence: true, uniqueness: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :rating, inclusion: { in: RATINGS }

  # can use -> instead of lambda
  scope :released, lambda {
    where('released_on < ?', Time.now).order('released_on desc')
  }
  scope :upcoming, lambda {
    where('released_on > ?', Time.now).order('released_on asc')
  }
  scope :recent, ->(max = 5) { released.limit(max) }
  # # or
  # scope :recent, lambda { |max=5| released.limit(max) }
  scope :hits, lambda { 
    released.where('total_gross >= ?', 300_000_000).order(total_gross: :desc)
  }
  scope :flops, lambda {
    released.where('total_gross < ?', 255_000_000).order(:total_gross)
  }
  scope :grossed_less_than, lambda { |amount|
    released.where('total_gross < ?', amount)
  }
  scope :grossed_greater_than, lambda { |amount|
    released.where('total_gross > ?', amount) 
  }

  # # Now handled by above scope.
  # def self.released
  #   where("released_on < ?", Time.now).order("released_on desc")
  # end

  def flop?
    !cult_movie? && !upcoming? && 
      (total_gross.blank? || total_gross < 225_000_000)
  end

  def cult_movie?
    reviews.count > 50 && reviews.average(:stars) > 4.0
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (self.average_stars / 5.0) * 100.0
  end

  def upcoming?
    Movie.upcoming.find_by(title: title).present?
  end

  def to_param
    slug
  end

  ##### Practice Custom Query Methods #####
  # def hit_movies
  #   where("total_gross >= ?", 300_000_000).order(total_gross: :desc)
  # end

  # def flop_movies
  #   where("total_gross < ?", 255_000_000).order(:total_gross)
  # end

  # def recently_added
  #   order("created_at desc").limit(3)
  # end

  private

    def set_slug
      self.slug = title.parameterize
    end
end
