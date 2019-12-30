class AddColumnToRetweets < ActiveRecord::Migration[5.2]
  def change
    add_column :retweets, :retweets_count, :integer
  end
end
