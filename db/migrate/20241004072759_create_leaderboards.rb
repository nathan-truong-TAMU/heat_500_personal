class CreateLeaderboards < ActiveRecord::Migration[7.0]
  def change
    create_table :leaderboards do |t|
      t.string :level_name
      t.integer :level_points

      t.timestamps
    end
  end
end
