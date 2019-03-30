class LeaguesController < ApplicationController
  before_action :require_admin, except: [:show]

  def show
    @league = League.find(params[:id])
    @owned_teams = Team.joins(:ownership).where("ownerships.league_id = ?", @league.id)
  end

  def new
    @league = current_user.leagues.new
  end

  def create
    @league = current_user.leagues.new(league_params)
    if @league.save
      redirect_to @league
    else
      render :new
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :start_date)
  end
end
