module AuthHelpers
  def login(user)
    post "/api/v1/login", params: {
      email: user.email,
      password: user.password
    }

    json["token"] # レスポンスから JWT を取り出す
  end

  def auth_headers(user)
    token = login(user)
    {
      "Authorization" => "Bearer #{token}"
    }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end