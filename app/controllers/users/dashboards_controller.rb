class Users::DashboardsController < ApplicationController
  before_action :authenticate

  def show
    @dashboard = Users::DashboardsController::Show.call(self, self)
  end
end
