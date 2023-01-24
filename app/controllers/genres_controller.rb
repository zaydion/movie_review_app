class GenresController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :set_genre, only: [:show, :edit, :update, :destroy]

  def index
    @genres = Genre.all
  end

  def show
    @movies = @genre.movies
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to @genre, notice: "Genre successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to @genre, notice: "Genre successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @genre.destroy
    redirect_to genres_url, status: :see_other, alert: "Genre successfully deleted!"
  end

  private

  def set_genre
    @genre = Genre.find_by!(slug: params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end
