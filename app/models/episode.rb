class Episode
  include ActiveModel::API
  include Collections

  attr_accessor :entry, :user
  attr_writer :collection

  delegate_missing_to :entry

  def play
    @play ||= collection.play_for(entry)
  end

  def play_later_item
    @play_later ||= collection.play_later_item_for(entry)
  end

  def following
    @following ||= collection.following_for(entry)
  end

  private

  attr_reader :collection
end
