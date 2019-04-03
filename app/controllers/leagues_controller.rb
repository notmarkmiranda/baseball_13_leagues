class LeaguesController < ApplicationController
  before_action :require_admin, except: [:show]

  def show
    @league = League.find(params[:id]).decorate
    @teams = Team.ordered_teams_by_league(@league.id)

    # this will eventually live on the league model or in settings
    @range = [*0..13]

    # TODO: make accomplishments after a certain Date
    # also filter on the view based on when the ownership started
    @accomplishments = Accomplishment.filter_by_league(@league)
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
