class AddUniqueIndexToFollowings < ActiveRecord::Migration[7.0]
  def change
    add_index :followings, [:feed_id, :user_id], unique: true
  end
end
