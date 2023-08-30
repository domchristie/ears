module UiHelper
  def ui
    @ui ||= Ui.new(self)
  end

  class Ui
    delegate_missing_to :@view_context

    def initialize(view_context)
      @view_context = view_context
    end

    def turn
      tag.attributes(data: {
        turn_exit: "motion-safe:turn-exit:animate-exit",
        turn_enter: "motion-safe:turn-enter:animate-enter"
      })
    end

    def heading
      tag.attributes class: "text-fl-xs uppercase tracking-wide font-semibold"
    end

    def form_controls
      tag.attributes class: "space-y-fl-xs"
    end

    def label
      tag.attributes class: "block text-fl-xs"
    end

    def text_input(size: :default)
      sizes = {
        default: "",
        sm: "p-1"
      }
      tag.attributes class: "#{sizes[size]} block w-full bg-grey-200 dark:bg-grey-800 border-transparent focus:bg-white dark:focus:bg-black disabled:bg-grey-100 disabled:text-grey-700 dark:disabled:bg-grey-900 dark:disabled:text-grey-400 disabled:cursor-not-allowed transition"
    end

    def button(size: :default, color: :default)
      sizes = {
        default: "px-3 py-2 text-sm leading-6",
        xs: "px-1.5 py-1 text-sm"
      }
      colors = {
        default: "bg-black dark:bg-white text-white dark:text-black border-transparent focus:border-blue-600 focus:ring-blue-600",
        secondary: "bg-white dark:bg-black text-grey-900 disabled:text-grey-500 dark:disabled:text-grey-400 dark:text-white border-grey-100 dark:border-grey-900 focus:border-blue-600 focus:ring-blue-600"
      }
      base = %w[group font-semibold rounded-none appearance-none relative flex items-center justify-center w-full tracking-wide text-center uppercase border cursor-pointer focus:outline-none focus:ring-1]
      tag.attributes class: [base, colors[color], sizes[size]]
    end
  end
end
