user = users.create :one, email: "one@example.com", verified: true
user.create_play_later_playlist!
plays.create user:, entry: entries.one, elapsed: 1.5

user = users.create :two, email: "two@example.com", verified: true
plays.create user:, entry: entries.one, elapsed: 1.5
