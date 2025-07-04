class Import::Fetch < ApplicationRecord
  class TooManyRedirects < StandardError; end

  attr_reader :response
  belongs_to :resource, polymorphic: true
  belongs_to :import, optional: true

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

    uri = URI(uri)
    @response = nil

    begin
      @navigation = Http::Navigation.new(Net::HTTP::Get.new(uri, request_headers))
      @response = @navigation.start

      case @response
      when Net::HTTPClientError, Net::HTTPServerError
        self.error = @response.class
      end
    rescue => exception
      self.error = exception.class
      # TODO: send to Honeybadger
    end

    update!({status_code: @response&.code}.compact)

    @response
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

  def error?
    error.present?
  end

  def new_permanent_location
    @navigation.new_permanent_location
  end
end
