class PlaylistVideo < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :video
end
