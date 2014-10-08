class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.references :author, index: true

      t.timestamps
    end
  end
end
