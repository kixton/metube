class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :listname
      t.references :user, index: true

      t.timestamps
    end
  end
end
