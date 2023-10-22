class Itunes::Search
  include Rails.application.routes.url_helpers
  attr_reader :term

  def initialize(term = "")
    @term = term
  end

  def start
    @response = HTTParty.get(url)
  end

  def results
    @results ||= json["results"].map do |result|
      SearchResult.new(
        image_url: result["artworkUrl600"],
        title: result["collectionName"],
        details: result["artistName"],
        path: itunes_feed_path(result["collectionId"])
      )
    end
  end

  def url
    "http://itunes.apple.com/search?media=podcast&term=#{term}"
  end

  def json
    @json ||= JSON.parse(@response.body)
  end
end
