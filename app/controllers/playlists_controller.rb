class PlaylistsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]
  
  # list all playlists - GET /playlists
  def index
    @playlists = Playlist.all
  end

  #show a single playlist - GET /playlists/:id
  def show
    @playlist = Playlist.find(params[:id])
  end

  #new playlist creation form - GET /playlists/new
  def new
    #creating a blank playlist instance for our form
    @playlist = current_user.playlists.new
  end

  #create a new playlist - POST /playlists
  def create
    @playlist = current_user.playlists.new(playlist_params)

    if @playlist.save
      redirect_to @playlist
    else
      render :new
    end
  end

  #edit playlist form - GET /playlists/:id/edit
  def edit
    @playlist = Playlist.find(params[:id])
  end

  #update an existing playlist - PUT /playlists/:id
  def update
    @playlist = Playlist.find(params[:id])

    if @playlist.update(playlist_params)
      redirect_to @playlist
    else
      render :edit
    end
  end

  #destroy an existing playlist - DELETE /playlists/:id
  def destroy
    @playlist = Playlist.find(params[:id])

    if @playlist.destroy
      redirect_to @playlist
    else
      render :destroy
    end

  end

  private
  def playlist_params
    params.require(:playlist).permit(:listname, :user_id)
  end

end
