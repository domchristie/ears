module UiHelper
  def ui
    @ui ||= Ui.new(self)
  end

  class Ui
    delegate_missing_to :@view_context

    def initialize(view_context)
      @view_context = view_context
    end

    def text_input(size: :default)
      sizes = {
        default: "",
        sm: "p-1"
      }
      tag.attributes class: "#{sizes[size]} block w-full bg-grey-200 dark:bg-grey-800 border-transparent focus:bg-white dark:focus:bg-black transition"
    end

    def button
      base = %w[rounded-none appearance-none relative flex items-center justify-center w-full font-semibold tracking-wide text-center uppercase border cursor-pointer focus:outline-none focus:ring-1]
      color = %w[bg-black dark:bg-white text-white dark:text-black border-transparent focus:border-blue-600 focus:ring-blue-600]
      size = %w[px-3 py-2 text-sm leading-6]
      tag.attributes class: [base, color, size]
    end
  end
end
