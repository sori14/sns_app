class AddColumnTitles < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :user_id, :integer
    add_column :rooms, :other_user_id, :integer
  end
end
