user = users.create_verified :one, email: "one@example.com"
user.create_play_later_playlist!
plays.create user:, entry: entries.one, elapsed: 1.5

user = users.create_verified :two, email: "two@example.com"
plays.create user:, entry: entries.one, elapsed: 1.5
