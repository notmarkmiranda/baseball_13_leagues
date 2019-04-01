class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @leagues = current_user.membered_or_admined_leagues
  end
end
