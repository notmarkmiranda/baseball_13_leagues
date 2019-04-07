class Accomplishment < ApplicationRecord
  belongs_to :team
  belongs_to :game
  has_many :winners

  default_scope { order(:date) }

  def self.filter_by_league(league)
    if league.active
      where("date>= :start_date AND number >= :bottom AND number <= :top", start_date: league.start_date, bottom: 0, top: 14)
    else
      where("date>= :start_date AND date <= :end_date AND number >= :bottom AND number <= :top", start_date: league.start_date, end_date: league.end_date, bottom: 0, top: 14)
    end
  end
end
