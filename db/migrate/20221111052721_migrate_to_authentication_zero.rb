class MigrateToAuthenticationZero < ActiveRecord::Migration[7.0]
  def up
    User.where.not(confirmed_at: nil).find_each do |u|
      u.update!(verified: true)
    end

    remove_column :users, :confirmed_at

    drop_table :active_sessions
  end

  def down
    create_table :active_sessions do |t|
      t.references :user, null: false, foreign_key: {on_delete: :cascade}
      t.string :user_agent
      t.string :ip_address
      t.string :remember_token, null: false

      t.timestamps
    end
    add_index :active_sessions, :remember_token, unique: true

    add_column :users, :confirmed_at, :datetime

    User.where(verified: true).find_each do |u|
      u.update!(confirmed_at: Time.current)
    end
  end
end
