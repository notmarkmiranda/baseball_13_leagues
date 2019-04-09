class Accomplishment < ApplicationRecord
  belongs_to :team
  belongs_to :game
  has_many :winners

  default_scope { order(:date) }

  def self.by_team_and_number_and_is_eligible?(team, number, league)
    acc = find_by(team_id: team.id, number: number)&.decorate
    return acc unless league.async_starts
    if acc
      ownership_start_date = Ownership.find_by(league: league, team: team)&.start_date
      return acc if ownership_start_date <= acc.date
    end
  end

  def self.filter_by_league(league)
    if league.active
      where("date>= :start_date AND number >= :bottom AND number <= :top", start_date: league.start_date, bottom: 0, top: 14)
    else
      where("date>= :start_date AND date <= :end_date AND number >= :bottom AND number <= :top", start_date: league.start_date, end_date: league.end_date, bottom: 0, top: 14)
    end
  end
end
