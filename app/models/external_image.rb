class ExternalImage
  def self.url(source_url)
    new(source_url).url
  end

  def initialize(source_url)
    @source_url = source_url
  end

  def url
    cdn.url({
      path: CGI.escape(@source_url),
      transformation: [{height: "512", width: "512"}],
      signed: true
    })
  end

  private

  def cdn
    @cdn ||= ImageKitIo::Client.new(
      Rails.application.credentials.imagekit.private_key,
      Rails.application.credentials.imagekit.public_key,
      Rails.application.credentials.imagekit.url_endpoint
    )
  end
end
