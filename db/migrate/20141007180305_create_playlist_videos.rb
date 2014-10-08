class CreatePlaylistVideos < ActiveRecord::Migration
  def change
    create_table :playlist_videos do |t|
      t.references :playlist, index: true
      t.references :video, index: true

      t.timestamps
    end
  end
end
