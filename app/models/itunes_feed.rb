class ItunesFeed
  attr_reader :apple_id

  def initialize(apple_id)
    @apple_id = apple_id
  end

  def feed_url
    @feed_url ||= fetch_feed_url
  end

  def apple_url
    "https://itunes.apple.com/lookup?id=#{apple_id}&entity=podcast"
  end

  private

  def fetch_feed_url
    url = URI(apple_url)
    request = Net::HTTP::Get.new(url)
    response = Net::HTTP.start(url.host, url.port, use_ssl: (url.scheme == "https")) do |http|
      http.request(request)
    end
    json = JSON.parse(response.body)
    json["results"][0]["feedUrl"]
  end
end
