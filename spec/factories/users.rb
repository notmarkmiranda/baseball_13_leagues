FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "asdf#{n}@email.com" }
    password { "password" }

    after(:create) { |user| user.confirm }
  end
end
