class AddWebSubHubUrlToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :web_sub_hub_url, :string
  end
end
