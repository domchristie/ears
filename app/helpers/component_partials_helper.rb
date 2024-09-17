module ComponentPartialsHelper
  def component_partial(options = {})
    Partial.new(self, options)
  end

  private

  class Partial
    attr_reader :options

    delegate_missing_to :@view_context

    def initialize(view_context, options)
      @view_context = view_context
      @contents = Hash.new { |h, k| h[k] = ActiveSupport::SafeBuffer.new }
      @options = options
      @content_options = {}
    end

    def content_for(name, content = nil, options = {}, &block)
      if content || block
        if block
          options = content || {}
          content = @view_context.capture(&block)
        end

        options_for(name, options)

        @contents[name] << content.to_s
        nil
      else
        @contents[name].presence
      end
    end

    def content_for?(name)
      @contents[name].present?
    end

    def options_for(name, options = nil)
      if options
        @content_options[name] = options
        nil
      else
        @content_options[name] || {}
      end
    end
  end
end
