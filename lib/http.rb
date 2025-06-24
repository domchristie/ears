class Http
  class TooManyRedirects < StandardError; end

  def self.start(request, follow_redirects: true, limit: 10)
    raise TooManyRedirects if limit <= 0

    uri = request.uri
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    if follow_redirects && response.is_a?(Net::HTTPRedirection)
      location = response["location"]
      new_uri = URI.join(uri, location) # supports relative redirects
      new_request = request.class.new(new_uri)
      request.each_header { |k, v| new_request[k] = v } # copy headers
      start(new_request, limit: limit - 1)
    else
      response
    end
  end
end
