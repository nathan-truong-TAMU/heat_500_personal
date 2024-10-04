class RefactoringMembers < ActiveRecord::Migration[7.0]
  def change
    rename_column :members, :member_name, :name
    rename_column :members, :member_points, :points
    remove_column :members, :executive_status
    add_column :members, :position, :string
    add_column :members, :dues_paid, :boolean
    add_column :members, :email, :string
  end
end
