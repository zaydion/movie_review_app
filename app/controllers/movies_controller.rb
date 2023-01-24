class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    case params[:filter]
    when "upcoming"
      @movies = Movie.upcoming
    when "recent"
      @movies = Movie.recent
    when "hits"
      @movies = Movie.hits
    when "flops"
      @movies = Movie.flops
    else
      @movies = Movie.released
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)

    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to @movie, notice: "Movie successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    redirect_to movies_path, status: :see_other, alert: "Movie successfully deleted!"
  end

  private

  def movie_params
    params.require(:movie)
      .permit(:title, :description, :rating, :released_on, :total_gross,
              :director, :duration, :image_file_name, genre_ids: [])
  end
end
