class RefactoringEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :event_link, :string
    rename_column :events, :event_name, :name
    rename_column :events, :event_datetime, :start_date
    rename_column :events, :event_end, :end_date
    rename_column :events, :event_points, :points
    rename_column :events, :event_description, :description
    add_column :events, :category, :string
    add_column :events, :location, :string
    add_reference :events, :link, null: false, foreign_key: true
  end
end
