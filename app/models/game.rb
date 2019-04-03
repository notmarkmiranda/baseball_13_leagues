class Game < ApplicationRecord
  belongs_to :home_team, foreign_key: 'home_team_id', class_name: 'Team'
  belongs_to :away_team, foreign_key: 'away_team_id', class_name: 'Team'
  has_many :accomplishments

  validates :home_team_id, presence: true
  validates :away_team_id, presence: true
  validates :mlb_game_id, presence: true

  after_create :create_accomplishments

  private

  def create_accomplishments
    Accomplishment.create(team_id: home_team_id, number: home_team_score, date: game_date_from_mlb_id, game_id: id)
    Accomplishment.create(team_id: away_team_id, number: away_team_score, date: game_date_from_mlb_id, game_id: id)
  end

  def game_date_from_mlb_id
    date = mlb_game_id.split('_').map(&:to_i)
    Date.new(date[0], date[1], date[2])
  end
end
