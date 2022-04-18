class CreateWebSubSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :web_sub_subscriptions do |t|
      t.references :feed, null: false, foreign_key: true
      t.string :hub_url, null: false
      t.datetime :expires_at
      t.string :secret, null: false

      t.timestamps
    end
  end
end
