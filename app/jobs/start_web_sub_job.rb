class StartWebSubJob < ApplicationJob
  queue_as :default

  retry_on WebSub::ServerError, Timeout::Error, SocketError, SystemCallError,
    wait: :polynomially_longer, attempts: 5

  # The WebSub may have been deleted by a newer subscription's confirmation
  discard_on ActiveJob::DeserializationError

  def perform(web_sub)
    web_sub.start
  end
end
