class Users::DashboardsController::Show < ControllerAction
  def call(controller)
    @controller = controller
  end

  def recently_played
    @recently_played ||= PlaysController::Index.call(@controller, limit: 3)
  end

  def recently_updated
    @recently_updated ||= EpisodesController::Index.call(@controller, limit: 3)
  end

  def play_later
    @play_later ||= QueuesController::Show.call(@controller, limit: 3)
  end
end
