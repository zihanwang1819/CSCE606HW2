class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_boxes = ['G', 'PG', 'PG-13', 'R']
      @movies = Movie.order(params[:sort])  #For part1
      @sort = params[:sort] || session[:sort]
      @selected_boxes = params[:ratings] || session[:ratings]
      
      #For part3
      if (params[:sort] == session[:sort]) == false
        if(params[:ratings] == session[:ratings]) == false
          params[:ratings] = @selected_boxes
          session[:ratings] = @selected_boxes
          params[:sort] = @sort
          session[:sort] = @sort
          flash.keep
          redirect_to movies_path(:sort=>params[:sort], :ratings =>params[:ratings])
        end
      end
      
      #For part2
      @boxes = {}
      for rating in @all_boxes 
        @boxes[rating] = @selected_boxes.nil?
        @selected_boxes.keys.include?(rating)
      end
    
      @movies = Movie.order @sort
      if @selected_boxes
        @movies = Movie.where(:rating => @selected_boxes.keys).order @sort
      end
    end
    
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
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