class Movie < ApplicationRecord
  def self.hits
    where("total_gross >= ?", 300_000_000).order(total_gross: :desc)
  end

  def self.flops
    where("total_gross < ?", 225_000_000).order(:total_gross)
  end

  def self.recently_added
    Movie.order(created_at: :desc).limit(3)
  end

  def self.released
    where("released_on <= ?", Time.current).order(released_on: :desc)
  end

  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end
end
