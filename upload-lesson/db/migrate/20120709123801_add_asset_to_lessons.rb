class AddAssetToLessons < ActiveRecord::Migration
   def self.up 
    #add_column :lessons, :asset_file_name, :string
    #add_column :lessons, :asset_content_type, :string
  #  add_column :lessons, :asset_file_size, :integer
   # add_column :lessons, :asset_updated_at, :datetime
  end

  def self.down
   # remove_column :lessons, :asset_file_name, :string
  #  remove_column :lessons, :asset_content_type, :string
   # remove_column :lessons, :asset_file_size, :integer
   # remove_column :lessons, :asset_updated_at, :datetime
  end
end
