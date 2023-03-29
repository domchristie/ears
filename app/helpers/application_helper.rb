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

  def turn_attributes
    tag.attributes(data: {
      turn_exit: turn_exit_class_names,
      turn_enter: turn_enter_class_names
    })
  end

  def turn_exit_class_names
    "motion-safe:turn-exit:animate-exit"
  end

  def turn_enter_class_names
    "motion-safe:turn-enter:animate-enter"
  end
end
