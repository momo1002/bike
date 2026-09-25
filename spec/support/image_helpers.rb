# frozen_string_literal: true

module ImageHelpers
  def test_image
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/files/test_image.jpg'),
      'image/jpeg'
    )
  end
end

RSpec.configure do |config|
  config.include ImageHelpers, type: :request
end
