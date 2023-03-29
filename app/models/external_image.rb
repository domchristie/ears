class ExternalImage
  def self.url(source_url, width: 512, height: 512)
    new(source_url).url(width:, height:)
  end

  def initialize(source_url)
    @source_url = source_url
  end

  def url(width: 512, height: 512)
    cdn.url({
      path: CGI.escape(@source_url),
      transformation: [{height:, width:}],
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
