FactoryBot.define do
  factory :league do
    sequence(:name) { |n| "Super Duper #{n}!" }
    start_date { "05/09/2015" }
    user
  end
end
