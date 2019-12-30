class AddIndexToRetweets < ActiveRecord::Migration[5.2]
  def change
    add_index :retweets, [:user_id, :micropost_id], unique: true
  end
end
