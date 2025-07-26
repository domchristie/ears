user = users.create_verified :two, email: "two@example.com"
followings.create user:, feed: feeds.one, sourceable: user

plays.create user:, entry: entries.one, feed: feeds.one, elapsed: 1.5
