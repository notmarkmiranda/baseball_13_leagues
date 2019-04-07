class WinnerChecker
  def self.check_for_winner(league)
    owned_teams = Team.owned_teams_by_league(league.id)
    winners = owned_teams.map do |team|
      self.create_winner(league, team) if team.accomplishment_count_by_league(league) == 14
    end

    league.end_today if winners.any?
  end

  def self.create_winner(league, team)
    user = league.ownerships.find_by(team: team).user
    user.winners.find_or_create_by(league: league, date: Date.today)
  end
end
