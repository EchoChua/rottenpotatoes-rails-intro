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
    sort_by = params[:sort_by] || session[:sort_by]    
    session[:sort_by] = sort_by
    
    @table_header = 'hilite' if sort_by == 'title'
    @release_date_header = 'hilite' if sort_by == 'release_date'
    @all_ratings = Movie.ratings


    if params.keys.include? "ratings"
      @ratings = params[:ratings] if params[:ratings].is_a? Array
      @ratings = params[:ratings].keys if params[:ratings].is_a? Hash
    elsif session.keys.include? "ratings"
      @ratings = session[:ratings]
    else
      @ratings = @all_ratings
    end
    @movies = Movie.where(:rating => @ratings).order(sort_by)
    session[:ratings] = @ratings

    #session[:sort_by] = @all_ratings
    #session[:ratings] = params[:ratings].keys if params.keys.include? "ratings"    
    #@ratings = session[:ratings]
    redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings]) if !((params.keys.include? 'sort_by') || (params.keys.include? 'ratings'))


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