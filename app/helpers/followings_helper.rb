module FollowingsHelper
  def following_dom_id(following)
    [
      "following",
      following.user_id,
      Base64.urlsafe_encode64(following.feed.url).delete("=")
    ].join("_")
  end
end
