module ComponentPartialsHelper
  def component_partial(options = {})
    Partial.new(self, options)
  end

  private

  class Partial
    DEFAULT_CONTENT_FOR_OPTIONS = [:flush]

    attr_reader :options

    delegate_missing_to :@view_context

    def initialize(view_context, options)
      @view_context = view_context
      @key = SecureRandom.uuid
      @options = options
      @content_options = {}
    end

    def helpers(&block)
      class_eval &block
    end

    def content_for(name, content = nil, options = {}, &block)
      if content || block
        if block
          options = content || {}
          content = @view_context.capture(&block)
        end

        options_for(name, options.without(*DEFAULT_CONTENT_FOR_OPTIONS))
      end

      @view_context.content_for(
        name_for(name),
        content,
        options.slice(*DEFAULT_CONTENT_FOR_OPTIONS)
      )
    end

    def content_for?(name)
      @view_context.content_for?(name_for(name))
    end

    def options_for(name, options = nil)
      if options
        @content_options[name_for(name)] = options
        nil
      else
        @content_options[name_for(name)] || {}
      end
    end

    def name_for(name)
      "#{name}_#{@key}".to_sym
    end
  end
end
