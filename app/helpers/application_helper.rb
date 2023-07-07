module ApplicationHelper
  def layout(name, args = {}, &block)
    render layout: "layouts/#{name}", locals: args, html: capture(&block)
  end

  def icon(name, options = {})
    size = options[:solid] ? 20 : 24
    options[:width] = options[:height] = size
    inline_svg_tag("heroicons/#{options.delete(:solid) ? "solid" : "outline"}/#{name}.svg", options)
  end

  class Props < Hash
    def deconstruct_keys(keys)
      Array(keys).to_h { |k| [k, nil] }.merge(self)
    end
  end

  def props(hash)
    Props[hash]
  end
end
