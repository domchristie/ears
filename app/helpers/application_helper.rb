module ApplicationHelper
  def icon(name, options = {})
    size = options[:solid] ? 20 : 24
    options[:width] = options[:height] = size
    inline_svg_tag("heroicons/#{options.delete(:solid) ? "solid" : "outline"}/#{name}.svg", options)
  end

  def turn_exit_class_names
    "motion-safe:turn-exit:animate-exit transform-gpu"
  end

  def turn_enter_class_names
    "motion-safe:turn-enter:animate-enter transform-gpu"
  end
end
