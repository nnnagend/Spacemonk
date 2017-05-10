class RemoveFbImageFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :fb_image, :string
  end
end
