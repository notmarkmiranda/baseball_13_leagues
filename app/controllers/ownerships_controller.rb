class OwnershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_league

  def new
    @ownership = league.ownerships.new
    authorize @ownership
  end

  def create
    @ownership = OwnershipCreator.new(ownership_params, params[:league_id])
    if @ownership.save
      redirect_to league
    else
      render :new
    end
  end

  private

  def ownership_params
    params.require(:ownership).permit(:user_id, :league_id, :team_id, user: [:email])
  end

  def load_league
    league
  end

  def league
    @league ||= League.find(params[:league_id])
  end
end
