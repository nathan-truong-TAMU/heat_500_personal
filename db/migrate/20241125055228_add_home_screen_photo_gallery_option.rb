class AddHomeScreenPhotoGalleryOption < ActiveRecord::Migration[7.0]
  def change
    add_column :photos, :home_page, :boolean
  end
end
