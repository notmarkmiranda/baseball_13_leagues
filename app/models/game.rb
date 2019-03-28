class Game < ApplicationRecord
  belongs_to :home_team, foreign_key: 'home_team_id', class_name: 'Team'
  belongs_to :away_team, foreign_key: 'away_team_id', class_name: 'Team'

  validates :home_team_id, presence: true, uniqueness: { scope: :away_team_id }
  validates :away_team_id, presence: true
  validates :mlb_game_id, presence: true
end
