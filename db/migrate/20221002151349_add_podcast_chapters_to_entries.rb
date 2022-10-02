class AddPodcastChaptersToEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :entries, :podcast_chapters_url, :string
    add_column :entries, :podcast_chapters_type, :string
  end
end
