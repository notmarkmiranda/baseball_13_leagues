class WinnerChecker
  attr_reader :league
  attr_reader :owned_teams

  def initialize(league)
    @league = league
    @owned_teams = Team.owned_teams_by_league(league)
  end

  def check!
    create_winners if league_winners.empty?
    return check_tiebreak if end_date_and_active?
    return league.end_today! if league_winners.count > 1
    league.finalize! if league_winners.one?
  end

  def self.check_for_winner(league)
    new(league).check!
  end

  private

  def check_tiebreak
    update_winners

    return unless every_winner_has_an_accomplishment?
    return finalize_single_winner! if there_is_only_one_winner?
    return remove_losers_on_multiple_ties! if there_are_more_than_one_winner_but_also_a_loser?

    league.end_today!
  end

  def create_winner(league, team)
    user = league.ownerships.find_by(team: team).user
    user.winners.find_or_create_by(league: league, date: Date.today)
  end

  def end_date_and_active?
    league.end_date && league.active? && league_winners.count > 1
  end

  def every_winner_has_an_accomplishment?
    league_winners.count == league_winners.map(&:accomplishment).compact.count
  end

  def finalize_single_winner!
    league_winners.find_by(tiebreak: max_runs).confirm!
    league.finalize!
  end

  def first_accomplishment_after_league_finish(team)
    team.accomplishments.where('accomplishments.date > ?', league.end_date).first
  end

  def league_winners
    @league_winners ||= league.winners
  end

  def max_runs
    @max_runs = league_winners.pluck(:tiebreak).max
  end

  def remove_losers_on_multiple_ties!
    tie_break_losers.each(&:destroy)
    league.end_today!
  end

  def there_are_more_than_one_winner_but_also_a_loser?
    tie_break_winners.many? && tie_break_losers.any?
  end

  def there_is_only_one_winner?
    tie_break_winners.one?
  end

  def tie_break_losers
    league_winners - tie_break_winners
  end

  def tie_break_winners
    league_winners.where(tiebreak: max_runs)
  end

  def update_winners
    league_winners.each do |winner|
      team = Ownership.find_by(user: winner.user, league: league).team
      new_accomplishment = first_accomplishment_after_league_finish(team)
      winner.update(accomplishment: new_accomplishment, tiebreak: new_accomplishment.number) if new_accomplishment
    end
  end

  def create_winners
    @winners ||= owned_teams.map do |team|
      create_winner(league, team) if team.accomplishment_count_by_league(league) == 14
    end
  end
end
