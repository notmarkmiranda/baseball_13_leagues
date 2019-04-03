class Team < ApplicationRecord
  has_many :home_games, foreign_key: 'home_team_id', class_name: 'Game'
  has_many :away_games, foreign_key: 'away_team_id', class_name: 'Game'
  has_many :ownerships
  has_many :accomplishments

  default_scope { order(name: :asc) }

  def accomplishment_count_by_league(league)
    accomplishments = Accomplishment.where(
      "date >= :league_start_date AND team_id = :team_id AND number >= :bottom AND number <= :top",
      league_start_date: league.start_date,
      team_id: id,
      bottom: 0,
      top: 14
    ).uniq { |acc| acc.number }
    accomplishments.count
  end

  def completion_percentage_by_league(league)
    (accomplishment_count_by_league(league) / 14.to_f * 100).floor
  end

  def owner_email
    owner_user.email
  end

  def self.owned_teams_by_league(league_id)
    joins(:ownerships)
      .where("ownerships.league_id = :league_id", league_id: league_id)
      .order(name: :asc)
  end

  def self.ordered_teams_by_league(league_id)
    owned_teams_by_league(league_id) + unowned_teams_by_league(league_id)
  end

  def self.unowned_teams_by_league(league_id)
    Team.all - owned_teams_by_league(league_id)
  end

  private

  def owner_user
    ownerships.first.user
  end
end
