class Fetch
  class TooManyRedirects < StandardError; end
  attr_reader :request, :response, :http

  SAFE_REQUEST_HEADERS = %w[
    user-agent,
    accept,
    accept-charset,
    accept-language,
    cache-control,
    etag,
    if-match,
    if-none-match,
    if-modified-since,
    if-unmodified-since
  ]

  SAFE_RESPONSE_HEADERS = %w[
    content-type
    content-length
    cache-control
    expires
    last-modified
    etag
    date
    x-request-id
    content-encoding
    vary
    accept-ranges
    location
  ]

  def initialize(request)
    @request = request
    add_user_agent
  end

  def start(limit: 10)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      @http = http
      follow(limit:)
    end
  end

  def user_agent
    "Ears/1.0 +https://www.ears.app"
  end

  def success?
    response&.is_a? Net::HTTPSuccess
  end

  def not_modified?
    response&.is_a? Net::HTTPNotModified
  end

  def not_found?
    response&.is_a? Net::HTTPNotFound
  end

  def requests
    @requests ||= []
  end

  def responses
    @responses ||= []
  end

  def uris = @uris ||= @requests.map(&:uri)

  def new_permanent_location
    [301, 308].include?(responses.first.code.to_i) &&
      responses.first&.[]("location")
  end

  def self.start(request)
    new(request).start
  end

  private

  def add_user_agent
    request["User-Agent"] = user_agent
  end

  def uri
    request.uri
  end

  def follow(limit:)
    raise TooManyRedirects if limit <= 0

    requests << request
    @response = (responses << http.request(request)).last

    if redirectable?
      if same_origin?(redirect_request)
        @request = redirect_request
        follow(limit: limit - 1)
      else
        @request = redirect_request
        start(limit: limit - 1)
      end
    else
      response
    end
  end

  def same_origin?(request)
    self.uri.scheme == request.uri.scheme &&
      self.uri.host == request.uri.host &&
      self.uri.port == request.uri.port
  end

  def redirectable?
    response["location"] &&
      [301, 302, 303, 307, 308].include?(response.code.to_i)
  end

  def redirect_request
    request_class = if [307, 308].include?(response.code.to_i)
      request.class
    elsif request.is_a?(Net::HTTP::Head)
      Net::HTTP::Head
    else
      Net::HTTP::Get
    end

    request_class.new(
      URI(response["location"]),
      SAFE_REQUEST_HEADERS.map { |key| [key, request[key]] }.compact.to_h
    )
  end
end
