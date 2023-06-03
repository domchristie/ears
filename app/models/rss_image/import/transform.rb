class RssImage::Import::Transform < Import::Transform
  def data
    return {} unless @source.present?

    @data ||= {
      url: @source.url,
      description: @source.description,
      title: @source.title,
      width: @source.width,
      height: @source.height,
      website_url: @source.link
    }
  end
end
