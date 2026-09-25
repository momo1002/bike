# frozen_string_literal: true

FactoryBot.define do
  factory :spot_image do
    association :spot

    image do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/files/test_image.jpg'),
        'image/jpeg'
      )
    end
  end
end
