class CreateAnnouncements < ActiveRecord::Migration[7.0]
  def change
    create_table :announcements do |t|
      t.references :member, null: false, foreign_key: true
      t.datetime :start_date
      t.string :description
      t.string :title

      t.timestamps
    end
  end
end
