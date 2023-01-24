class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie
  before_action :set_review, only: [:edit, :update, :destroy]

  def index
    @reviews = @movie.reviews.order(created_at: :desc)
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_reviews_url, notice: "Thanks for your review!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to movie_reviews_url, notice: "Review successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to movie_reviews_path(@movie), status: :see_other, alert: "Review successfully deleted!"
  end

  private

  def review_params
    params.require(:review).permit(:stars, :comment)
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
