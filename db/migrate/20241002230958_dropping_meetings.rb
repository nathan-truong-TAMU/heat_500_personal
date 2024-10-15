class DroppingMeetings < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :meetings_members, :meetings
    drop_table :meetings
    drop_table :meetings_members
  end
end
