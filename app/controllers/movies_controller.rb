class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.find(:all, :select => 'DISTINCT rating').map {|x| x.rating}
    if params.has_key? :ratings
      if params[:ratings].is_a?(Array)
        @ratings = params[:ratings]
      else
        @ratings = params[:ratings].keys
      end
      session[:ratings] = @ratings
    elsif session.has_key? :ratings
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = @all_ratings
    end

    @movies = Movie.where(:rating => @ratings)

    if params.has_key? :sort_by
      session[:sort_by] = params[:sort_by]
      @movies = @movies.order(params[:sort_by])
      if redirect
        redirect_to movies_path :ratings => @ratings, :sort_by => params[:sort_by]
      end
    elsif session.has_key? :sort_by
      @movies = @movies.order(session[:sort_by])
        redirect_to movies_path :ratings => @ratings, :sort_by => session[:sort_by]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
