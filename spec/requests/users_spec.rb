require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /signup" do
    context "登録情報が正しい場合" do
      it "ユーザー登録に成功する" do
        expect do
          post signup_path, params: {
            user: {
              username: "もも",
              email: "momo@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        end.to change(User, :count).by(1)

        expect(response).to redirect_to(login_path)
      end
    end

    context "登録情報が不正な場合" do
      it "ユーザー登録に失敗する" do
        expect do
          post signup_path, params: {
            user: {
              username: "",
              email: "",
              password: "123",
              password_confirmation: "456"
            }
          }
        end.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "既に登録済みのメールアドレスの場合" do
    before do
      User.create!(
        username: "既存ユーザー",
        email: "momo@example.com",
        password: "password",
        password_confirmation: "password"
      )
    end

    it "ユーザー登録に失敗する" do
      expect do
        post signup_path, params: {
          user: {
            username: "もも",
            email: "momo@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end