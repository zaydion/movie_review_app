class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :critics, through: :reviews, source: :user
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
                                with: /\w+\.(jpg|png)\z/i,
                                message: "must be a JPG or PNG image",
                              }
  validates :rating, inclusion: { in: RATINGS }

  scope :released, -> { where("released_on <= ?", Time.current).order(released_on: :desc) }
  scope :hits, -> { released.where("total_gross >= ?", 300_000_000).order(total_gross: :desc) }
  scope :flops, -> { released.where("total_gross < ?", 225_000_000).order(:total_gross) }
  scope :recently_added, ->(limit = 3) { order(created_at: :desc).limit(limit) }
  scope :upcoming, -> { where("released_on >= ?", Time.current).order(released_on: :asc) }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :grossed_less_than, ->(amount) { where("total_gross <= ?", amount) }
  scope :grossed_greater_than, ->(amount) { where("total_gross >= ?", amount) }

  def flop?
    if cult_classic?
      false
    else
      total_gross.blank? || total_gross < 225_000_000
    end
  end

  def average_stars
    reviews.average(:stars) || 0
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100.0
  end

  def cult_classic?
    reviews.size > 50 && reviews.average(:stars) >= 4.0
  end
end
