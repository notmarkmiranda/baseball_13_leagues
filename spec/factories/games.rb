FactoryBot.define do
  factory :game do
    home_team
    away_team
    home_team_score { 12 }
    away_team_score { 10 }
    mlb_game_id { "mlb_game_id" }
  end
end
