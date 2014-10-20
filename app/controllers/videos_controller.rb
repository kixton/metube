require 'rest_client'
class VideosController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def video_params
    params.require(:video).permit(:name, :video)
  end

  # list all videos - GET /videos
  def index
    @videos = Video.all
  end

  #show a single video - GET /videos/:id
  def show
    @videos = Video.all
    @video = Video.find(params[:id])
    @playlists = Playlist.all

    api_key = "&key=" + ENV["GOOGLE_API"]
    snippet_url = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id="
    statistics_url = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id="
    snippet_path = snippet_url + @video.url + api_key 
    statistics_path = statistics_url + @video.url + api_key 
    snippet_obj = RestClient.get(snippet_path)
    statistics_obj = RestClient.get(statistics_path)

    snippet_JSON = JSON.parse(snippet_obj)
    statistics_JSON = JSON.parse(statistics_obj)

    @vid_description = snippet_JSON["items"][0]["snippet"]["description"]
    @view_count = statistics_JSON["items"][0]["statistics"]["viewCount"]

    if user_signed_in?
      @user = User.find(current_user)
    end
  end

  #new video creation form - GET /videos/new
  def new
    #creating a blank video instance for our form

  end

  #create a new video - POST /videos
  def create

    @video = current_user.videos.new(video_params)
    # @video.file_name = params[:video][:video].original_filename

    @vidupload = VideoUploader.new
    @vidupload.store!(params[:video][:video])
    
    if @video.save
      redirect_to @video
    else
      render :new
    end
  end

  #edit video form - GET /videos/:id/edit
  def edit
    @video = Video.find(params[:id])
  end

  #update an existing video - PUT /videos/:id
  def update
    @video = Video.find(params[:id])

    if @video.update(video_params)
      redirect_to @video
    else
      render :edit
    end
  end

  #destroy an existing video - DELETE /videos/:id
  def destroy
    @video = Video.find(params[:id])

    if @video.destroy
      redirect_to @video
    else
      render :destroy
    end

  end

  def add_to_playlist
    @video = Video.find(params[:id])
    @playlist = Playlist.find(params[:playlist_id])

    # if playlist already includes the video, do not add
    if @playlist == @video.playlists.find_by(id: params[:playlist_id])
      puts "playlist already includes video"
    else
      @video.playlists << @playlist
    end
  end

  private
  def video_params
    params.require(:video).permit(:title, :url, :author_id)
  end

end
