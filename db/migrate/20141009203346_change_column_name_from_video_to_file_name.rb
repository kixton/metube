class ChangeColumnNameFromVideoToFileName < ActiveRecord::Migration
  def change
    rename_column :videos, :video, :file_name
  end
end
