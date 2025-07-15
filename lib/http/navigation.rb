class Http::Navigation
  class TooManyRedirects < StandardError; end
  attr_reader :current_request, :current_response, :http

  SAFE_HEADERS = [
    "User-Agent",
    "Accept",
    "Accept-Charset",
    "Accept-Language",
    "Cache-Control",
    "ETag",
    "If-Match",
    "If-None-Match",
    "If-Modified-Since",
    "If-Unmodified-Since"
  ]

  def initialize(request)
    @current_request = request
  end

  def start(limit: 10)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      @http = http
      follow(limit:)
    end
  end

  def requests
    @requests ||= []
  end

  def responses
    @responses ||= []
  end

  def new_permanent_location
    first_clean_permanent_redirect&.[]("location")
  end

  def self.start(request)
    new(request).start
  end

  private

  def uri
    current_request.uri
  end

  def follow(limit:)
    raise TooManyRedirects if limit <= 0

    requests << current_request
    @current_response = (responses << http.request(current_request)).last

    if redirectable?
      if same_origin?(redirect_request)
        @current_request = redirect_request
        follow(limit: limit - 1)
      else
        @current_request = redirect_request
        start(limit: limit - 1)
      end
    else
      current_response
    end
  end

  def same_origin?(request)
    self.uri.scheme == request.uri.scheme &&
      self.uri.host == request.uri.host &&
      self.uri.port == request.uri.port
  end

  def redirectable?
    current_response["location"] &&
      [301, 302, 303, 307, 308].include?(current_response.code.to_i)
  end

  def redirect_request
    request_class = if [307, 308].include?(current_response.code.to_i)
      current_request.class
    elsif current_request.is_a?(Net::HTTP::Head)
      Net::HTTP::Head
    else
      Net::HTTP::Get
    end

    request_class.new(
      URI(current_response["location"]),
      SAFE_HEADERS.map { |key| [key, current_request[key]] }.compact.to_h
    )
  end

  def first_clean_permanent_redirect
    seen_temporary = false

    responses.find do |response|
      code = response.code.to_i

      seen_temporary = true if [302, 303, 307].include?(code)
      [301, 308].include?(code) && !seen_temporary
    end
  end
end
