class Users::DashboardsController < ApplicationController
  before_action :authenticate

  def show
    @dashboard = User::Dashboard.new(Current.user)
  end
end
