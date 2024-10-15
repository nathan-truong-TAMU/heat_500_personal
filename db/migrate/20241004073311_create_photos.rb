class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :path
      t.string :alt_text
      t.string :description

      t.timestamps
    end
  end
end
