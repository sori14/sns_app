class CreateReplies < ActiveRecord::Migration[5.2]
  def change
    create_table :replies do |t|
      t.string :content
      t.references :user
      t.references :micropost

      t.timestamps
    end
  end
end
