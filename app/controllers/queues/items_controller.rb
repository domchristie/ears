class Queues::ItemsController < ApplicationController
  def create
    queue_item = current_user.queue.prepend_entry(
      Entry.find(params[:playlist_item][:entry_id])
    )
    render partial: "queues/items/form", locals: {queue_item: queue_item}
  end

  def destroy
    @queue_item = current_user.queue.remove_entry(
      Entry.find_by_hashid(params[:entry_id])
    ) || head(:not_found)
  end
end
