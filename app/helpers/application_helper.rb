module ApplicationHelper
  def icon(name, options = {})
    size = options[:solid] ? 20 : 24
    options[:width] = options[:height] = size
    inline_svg_tag("heroicons/#{options.delete(:solid) ? "solid" : "outline"}/#{name}.svg", options)
  end

  def turn_exit_class_names
    "motion-safe:turn-exit:animate-exit"
  end

  def turn_enter_class_names
    "motion-safe:turn-enter:animate-enter"
  end

  def external_image_url(url)
    imagekitio = ImageKitIo::Client.new(
      Rails.application.credentials.imagekit.private_key,
      Rails.application.credentials.imagekit.public_key,
      Rails.application.credentials.imagekit.url_endpoint,
    )
    imagekitio.url({
      path: CGI.escape(url),
      transformation: [{height: "512", width: "512"}],
      signed: true
    })
  end
end
