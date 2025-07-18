class Extraction < ApplicationRecord
  enum :status, [:success, :not_modified, :not_found, :error]
  attr_accessor :fetch
  has_many :import_extractions, dependent: :destroy
  has_many :imports, through: :import_extractions
  has_one :recent_import_extraction, -> { order(created_at: :desc) }, class_name: "ImportExtraction"
  has_one :recent_import, through: :recent_import_extraction, source: :import

  def self.start_with_fetch(*args, &block)
    new(*args).start_with_fetch(&block)
  end

  def start_with_fetch
    begin
      response = fetch.start

      case response
      when Net::HTTPSuccess
        self.result = block_given? ? yield(fetch) : {body: response.body}
        success!
      when Net::HTTPNotModified
        not_modified!
      when Net::HTTPNotFound, Net::HTTPGone
        not_found!
      when Net::HTTPClientError, Net::HTTP::ServerError, Socket::ResolutionError
        self.error_class = response.class
        error!
      end
    rescue => exception
      self.error_class = exception.class
      error!
      raise
    ensure
      save!
    end
    self
  end

  def resource
    recent_import&.resource
  end
end
