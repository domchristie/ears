class ControllerAction
  def initialize(controller)
    @params = controller.params
    @current_user = controller.current_user
  end

  def self.call(controller, ...)
    instance = new(controller)
    instance.call(...)
    instance
  end

  def call
  end

  private

  attr_reader :params, :current_user
end
