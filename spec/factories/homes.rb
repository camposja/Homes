FactoryBot.define do
  factory :home do
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    bedrooms { rand(1..6) }
    baths { rand(1..4) }
    square_feet { rand(800..5000) }
    price { rand(100000..1000000) }
    description { Faker::Lorem.paragraph }
    association :created_by, factory: :user

    trait :with_image do
      after(:build) do |home|
        fixture_path = Rails.root.join("spec/fixtures/test_image.jpg")
        home.image = File.open(fixture_path)
      end
    end
  end
end
