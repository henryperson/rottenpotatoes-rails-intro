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
    if session[:sort_by_title].nil?
      session[:sort_by_title] = false
    end
    
    if session[:sort_by_release_date].nil?
      session[:sort_by_release_date] = false
    end
    
    @all_ratings = Movie.get_ratings
    @movies = Movie.all
    
    if session[:ratings].nil?
      session[:ratings] = @all_ratings
    end
    
    if not params[:ratings].nil?
      session[:ratings] = params[:ratings].keys
      @movies = Movie.where(rating: session[:ratings])
    end
    
    if not params[:sort_by].nil?
      if params[:sort_by] == "title"
        session[:sort_by_title] = true
        session[:sort_by_release_date] = false
        
      elsif params[:sort_by] == "release_date"
        session[:sort_by_release_date] = true
        session[:sort_by_title] = false
      end
    end
    
    if session[:sort_by_title]
      @movies = Movie.where(rating: session[:ratings]).order(:title)
    elsif session[:sort_by_release_date]
      @movies = Movie.where(rating: session[:ratings]).order(:release_date)
    else
      @movies = Movie.where(rating: session[:ratings])
    end
    
    @sort_by_title = session[:sort_by_title]
    @sort_by_release_date = session[:sort_by_release_date]
    
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
