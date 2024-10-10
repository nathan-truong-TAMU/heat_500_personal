class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.integer :quantity
      t.decimal :price
      t.string :name
      t.string :description
      t.string :category
      t.string :photo_path

      t.timestamps
    end
  end
end
