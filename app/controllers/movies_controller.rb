class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings #load movie ratings from model
    @movies = Movie.all #get all movies
    
    @sort = params[:sort] || session[:sort] #determine whether or not we are remembering an old session for sorting
    @filter = params[:ratings] || session[:ratings] #do the same for the filtering
    
    session[:sort] = @sort #update the session so it can be remembered later
    session[:ratings] = @filter #do the same for ratings
    
    if @filter.present?
      @movies = Movie.with_ratings(@filter.keys) #filter through a function defined in the model
    end
    
    case @sort
    when "title"
      @movies = Movie.with_ratings(@filter.keys).order("title") #order only the movies we've allowed through the filter
      @title_highlighter = "hilite"
    when "release_date"
      @movies = Movie.with_ratings(@filter.keys).order("release_date") #same here
      @release_highlighter = "hilite"
    end
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

end
