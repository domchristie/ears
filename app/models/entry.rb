class Entry < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model
  pg_search_scope(
    :entry_search,
    against: [[:title, "A"], :itunes_summary, :description, :content],
    using: {tsearch: {prefix: true}}
  )

  belongs_to :feed, touch: true
  has_many :plays, dependent: :destroy
  has_one :recent_play, -> {
    where("plays.id = (SELECT id FROM plays WHERE plays.entry_id = entries.id ORDER BY created_at DESC LIMIT 1)")
  }, class_name: "Play"
  has_one :play_later_item, class_name: "PlaylistItem"
  has_one :table_of_contents, dependent: :destroy
  has_many :playlist_items, dependent: :destroy

  scope :followed_by, ->(user) { includes(:following).where(followings: {user:}) }
  scope :search, ->(term) { term.present? ? entry_search(term) : all }

  def enclosure_url
    Rails.env.development? ? "https://cloth.ears.app/#{super}" : super
  end

  def duration
    itunes_duration
  end

  def summary
    itunes_summary || description
  end

  def image_url
    itunes_image_url || super || feed.image_url
  end

  def media_session_metadata
    image_url = ExternalImage.url(feed.image_url)
    {
      title: title,
      artist: feed.title,
      album: published_at.to_date.to_fs(:short),
      artwork: [
        {src: image_url, width: 512, height: 512, sizes: "96x96"},
        {src: image_url, width: 512, height: 512, sizes: "128x128"},
        {src: image_url, width: 512, height: 512, sizes: "192x192"},
        {src: image_url, width: 512, height: 512, sizes: "256x256"},
        {src: image_url, width: 512, height: 512, sizes: "384x384"},
        {src: image_url, width: 512, height: 512, sizes: "512x512"}
      ]
    }
  end

  def most_recent_play_by(user)
    plays.most_recent_by(user)
  end

  def upcoming_play_by(user)
    plays.build({user: user, elapsed: 0, remaining: duration}.compact)
  end

  def play_by(user)
    most_recent_play_by(user) || upcoming_play_by(user)
  end

  def play_later_item_for(user)
    @play_later_item_for ||= user.play_later_playlist.items.find_or_initialize_by(entry: self)
  end

  def show_notes
    @show_notes ||= ShowNotes.new(self)
  end
end
