FactoryBot.define do
  factory :spot do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    association :user
  end
end
