FactoryBot.define do
  factory :ownership do
    user
    league
    team
    active { true }
    paid { false }
  end
end
