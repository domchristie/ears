class Users::DashboardsController < ApplicationController
  def show
    @dashboard = Show.call(self, self)
  end
end
