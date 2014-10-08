class Playlist < ActiveRecord::Base
  has_many :playlist_videos
  has_many :videos, through: :playlist_videos
  
  belongs_to :user
end
