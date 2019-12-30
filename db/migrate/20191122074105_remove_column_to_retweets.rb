class RemoveColumnToRetweets < ActiveRecord::Migration[5.2]
  def up
    remove_column :retweets, :retweets_count
  end

  def down
    add_column :retweets, :retweets_count, :integer
  end
end
