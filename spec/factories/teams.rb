FactoryBot.define do
  factory :team, aliases: [:home_team, :away_team] do
    name { "MyString" }
    mlb_id { "MyString" }
  end
end
