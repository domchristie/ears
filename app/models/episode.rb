class Episode
  include ActiveModel::API

  attr_accessor :entry, :user
  attr_writer :play, :queue_item, :following, :collection

  delegate_missing_to :entry

  def play
    @play ||= @collection.play_for(entry)
  end

  def queue_item
    @queue_item ||= @collection.queue_item_for(entry)
  end

  def following
    @following ||= @collection.following_for(entry)
  end
end
