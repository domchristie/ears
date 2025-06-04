# Wrapper around Entry that is tied to a user
class Episode
  include ActiveModel::API
  include Collections

  attr_accessor :entry, :user, :collection

  delegate_missing_to :entry

  def play
    @play ||= collection&.play_for(entry) || entry.play_by(user)
  end

  def play_later_item
    @play_later ||= collection&.play_later_item_for(entry) ||
      entry.play_later_item_for(user)
  end

  def following
    @following ||= collection&.following_for(entry) ||
      entry.feed.following_for(user)
  end
end
