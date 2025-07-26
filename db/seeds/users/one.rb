user = users.create_verified :one, email: "one@example.com"
followings.create user:, feed: feeds.one, sourceable: user

playlists.create :play_later, user:, name: "Play Later", type: PlayLaterPlaylist

plays.create user:, entry: entries.one, feed: feeds.one, elapsed: 1.5
