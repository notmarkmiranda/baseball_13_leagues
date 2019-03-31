FactoryBot.define do
  factory :membership do
    league
    user
    role { 1 }
  end
end
