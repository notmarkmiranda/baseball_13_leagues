class Team < ApplicationRecord
  has_many :home_games, foreign_key: 'home_team_id', class_name: 'Game'
  has_many :away_games, foreign_key: 'away_team_id', class_name: 'Game'
  has_many :ownership

  def owner_email
    owner_user.email
  end

  private

  def owner_user
    ownership.first.user
  end
end
