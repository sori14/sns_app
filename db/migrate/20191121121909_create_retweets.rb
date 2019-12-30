class CreateRetweets < ActiveRecord::Migration[5.2]
  def change
    create_table :retweets do |t|
      t.references :user, foreign_key: true
      t.references :micropost, foreign_key: true

      t.timestamps
    end
  end
end
