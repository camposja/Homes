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
        data = StringIO.new("fake image data")
        data.instance_eval do
          def original_filename; "test_image.jpg"; end
          def content_type; "image/jpeg"; end
        end
        home.image = data
      end
    end
  end
end 