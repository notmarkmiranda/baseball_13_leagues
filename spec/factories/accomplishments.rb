FactoryBot.define do
  factory :accomplishment do
    team
    number { 1 }
    date { "2015-05-09" }
    game
  end
end
