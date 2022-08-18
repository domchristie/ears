class Itunes::Search
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
        meta: {url: result["feedUrl"]}
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
