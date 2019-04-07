class WinnerChecker
  attr_reader :league
  attr_reader :owned_teams

  def initialize(league)
    @league = league
    @owned_teams = Team.owned_teams_by_league(league.id)
  end

  def check!
    return check_tiebreak if end_date_and_active?
    return league.end_today! if winners.count > 1
    league.finalize! if winners.one?
  end

  def self.check_for_winner(league)
    new(league).check!
  end

  private

  def first_accomplishment_after_league_finish(team)
    team.accomplishments.where('accomplishments.date > ?', league.end_date).first
  end

  def check_tiebreak
    winners = league.winners
    winners.each do |winner|
      team = Ownership.find_by(user: winner.user, league: winner.league).team
      new_accomplishment = first_accomplishment_after_league_finish(team)
      winner.update(accomplishment: new_accomplishment, tiebreak: new_accomplishment.number) if new_accomplishment
    end

    if winners.count == winners.map(&:accomplishment).compact.count
      max_runs = winners.pluck(:tiebreak).max
      if winners.where(tiebreak: max_runs).count == 1
        winners.find_by(tiebreak: max_runs).confirm!
        league.finalize!
      else
        league.end_today!
      end
      # figure out if one accomplishment is greater than the other and confirm that winner
      # otherwise (there is a tie) move the league end date forward
    end
  end

  def create_winner(league, team)
    user = league.ownerships.find_by(team: team).user
    user.winners.find_or_create_by(league: league, date: Date.today)
  end

  def end_date_and_active?
    league.end_date && league.active? && league.winners_count > 1
  end

  def winners
    @winners ||= owned_teams.map do |team|
      create_winner(league, team) if team.accomplishment_count_by_league(league) == 14
    end
  end
end
