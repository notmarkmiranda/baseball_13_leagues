class Accomplishment < ApplicationRecord
  belongs_to :team
  belongs_to :game

  default_scope { order(:date) }

  def self.filter_by_league(league)
    if league.active
      where("date>= :start_date", start_date: league.start_date)
    else
      where("date>= :start_date AND date <= :end_date", start_date: league.start_date, end_date: league.end_date)
    end
  end

  def short_date
    date.strftime("%m/%-e/%y")
  end
end
