class CreateWebSubSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :web_subs do |t|
      t.string :feed_url, null: false
      t.string :hub_url, null: false
      t.datetime :expires_at
      t.string :secret, null: false

      t.timestamps
    end

    add_index :feeds, :url, unique: true
    add_index :web_subs, :feed_url
    add_foreign_key :web_subs, :feeds, column: :feed_url, primary_key: :url
  end
end
