class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    valid_sorts = ['title', 'release_date']
    @movie_title_classes = ''
    @release_title_classes = ''
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings] || session[:ratings] || Movie.ratings_to_show
    @movies = Movie.with_ratings(@ratings_to_show)
  
    if params.has_key?(:sort) && valid_sorts.include?(params[:sort])
      sort = params[:sort]
      @movies = @movies.order(sort)
      session[:sort] = sort
      @movie_title_classes = 'hilite bg-warning' if sort == 'title'
      @release_title_classes = 'hilite bg-warning' if sort == 'release_date'
    elsif session[:sort].present?
      sort = session[:sort]
      @movies = @movies.order(sort)
      @movie_title_classes = 'hilite bg-warning' if sort == 'title'
      @release_title_classes = 'hilite bg-warning' if sort == 'release_date'
    end
    session[:ratings] = @ratings_to_show

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
