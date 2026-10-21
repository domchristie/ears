class AddWebSubTopicUrlToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :feeds, :web_sub_topic_url, :string
  end
end
