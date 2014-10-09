class Video < ActiveRecord::Base
  has_many :playlist_videos
  has_many :playlists, through: :playlist_videos
  belongs_to :author, class_name: "User"
  
  mount_uploader :video, VideoUploader 
  
  validates :title, presence: true
  validates :author_id, presence: true 
end
