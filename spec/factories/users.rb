FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    provider { 'github' }
    uid { Faker::Number.number(digits: 8).to_s }
    nickname { Faker::Internet.username }
    access_token { Faker::Crypto.md5 }
  end
end 