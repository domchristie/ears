class AddUserIdToPlays < ActiveRecord::Migration[7.0]
  def up
    add_reference :plays, :user, foreign_key: true

    Play.update_all(user_id: User.first.id)

    change_column_null :plays, :user_id, false
    add_index :plays, [:user_id, :entry_id], unique: true
  end

  def down
    remove_reference :plays, :user
  end
end
