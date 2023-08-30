class Users::DashboardsController < ApplicationController
  before_action :authenticate

  def show
    @dashboard = Show.call(self, self)
  end
end
