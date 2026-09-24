require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "POST /login" do
    let!(:user) do
      User.create!(
        username: "もも",
        email: "momo@example.com",
        password: "password",
        password_confirmation: "password"
      )
    end

    context "正しい情報の場合" do
      it "ログインに成功する" do
        post login_path, params: {
          email: user.email,
          password: "password"
        }

        expect(response).to redirect_to(root_path)
      end
    end

    context "パスワードが間違っている場合" do
      it "ログインに失敗する" do
        post login_path, params: {
          email: user.email,
          password: "wrong_password"
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "存在しないメールアドレスの場合" do
      it "ログインに失敗する" do
        post login_path, params: {
          email: "nothing@example.com",
          password: "password"
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /logout" do
    it "ログアウトできる" do
      get logout_path

      expect(response).to redirect_to(root_path)
    end
  end
end
