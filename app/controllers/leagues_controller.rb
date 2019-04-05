class LeaguesController < ApplicationController
  before_action :require_admin, except: [:show]

  def show
    @league = League.find_by_token(params[:token]).decorate
    @teams = TeamDecorator.decorate_collection(Team.ordered_teams_by_league(@league.id))
    @range = [*0..13]
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
