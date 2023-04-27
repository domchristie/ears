class Fetch < ApplicationRecord
  class TooManyRedirects < StandardError; end

  attr_reader :response, :uri
  belongs_to :resource, polymorphic: true
  has_one :synchronization, dependent: :destroy

  def user_agent
    "Ears/1.0 #{self.class} +https://www.ears.app"
  end

  def request_headers
    @request_headers ||= {"User-Agent" => user_agent}
  end

  def response_headers
    @response_headers ||= response&.each_header.to_h
  end

  def response_body
    @response_body ||= response&.read_body
  end

  def get(uri, limit: 10)
    raise TooManyRedirects if limit == 0

    @uri = URI(uri)
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true if @uri.scheme == "https"
    @response = nil

    begin
      @http.start do
        request = Net::HTTP::Get.new(@uri, request_headers)
        @response = @http.request(request)
        case @response
        when Net::HTTPSuccess
          @response
        when Net::HTTPRedirection
          @redirected_permanently = @response.is_a?(Net::HTTPMovedPermanently)
          return get(@response["location"], limit: limit - 1)
        when Net::HTTPServerError, Net::HTTPClientError
          update!(error: @response.class)
        end
      end
    rescue => exception
      update!(error: exception.class)
      # TODO: send to Honeybadger
    end

    @response
  end

  def success?
    response&.is_a? Net::HTTPSuccess
  end

  def not_modified?
    response&.is_a? Net::HTTPNotModified
  end

  def error?
    error.present?
  end

  def redirected_permanently?
    @redirected_permanently
  end
end
