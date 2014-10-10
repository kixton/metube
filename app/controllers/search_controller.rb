class SearchController < ApplicationController

  def index
    @apiKey = "&key=" + ENV["GOOGLE_API"]
    @baseUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&videoEmbeddable=true&type=video&maxResults=12&q="
    @urlPath = @baseUrl + params[:search_keyword] + @apiKey 
    @obj = RestClient.get(@urlPath)

    render json: results
    
    # @objParsed = JSON.parse(@obj)

  end


end
