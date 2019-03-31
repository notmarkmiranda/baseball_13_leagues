FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "asdf#{n}@email.com" }
    password { "password" }

    trait :admin do
      role { 1 }
    end

    after(:create) { |user| user.confirm }
  end
end
