class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
    @all_ratings = Movie.all_ratings
    
    if !params[:ratings]
      if session[:ratings]
        @ratings_to_show = session[:ratings]
      else
        @ratings_to_show = []
      end
    else
      @ratings_to_show = params[:ratings].keys
    end
    ####
    if !params[:columns]
      if session[:columns]
        @columns = session[:columns] 
      else
        @columns = []
      end
    else
      @columns = params[:columns].keys
    end

    if !params[:sort]
      if session[:sort]
        @sort = session[:sort]
      else
        @sort = ''
      end
    else
      @sort = params[:sort]
    end

    if @sort == 'title'
      @movies = Movie.with_ratings(@columns).order(:title)
    elsif @sort == 'release_date'
      @movies = Movie.with_ratings(@columns).order(:release_date)
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end

    session[:ratings] = @ratings_to_show
    session[:columns] = @columns
    session[:sort] = @sort
    # session.clear

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end