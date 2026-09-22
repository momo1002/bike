require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    context "有効なユーザーの場合" do
      it "有効であること" do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context "無効なユーザーの場合" do
      it "email が必須であること" do
        user = build(:user, email: nil)
        expect(user).to_not be_valid
      end

      it "password が必須であること" do
        user = build(:user, password: nil)
        expect(user).to_not be_valid
      end
    end
  end

  describe "パスワード認証" do
    it "正しいパスワードで認証できること" do
      user = create(:user, password: "password123")
      expect(user.authenticate("password123")).to be_truthy
    end

    it "間違ったパスワードでは認証できないこと" do
      user = create(:user, password: "password123")
      expect(user.authenticate("wrongpass")).to be_falsey
    end
  end

  describe "email のバリデーション" do
    it "email が必須であること" do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "email の形式が正しいこと" do
      user = build(:user, email: "invalid-email")
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it "重複した email は登録できないこと" do
      create(:user, email: "test@example.com")   # 先に1件作る
      user = build(:user, email: "test@example.com")  # 同じ email を作る

      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe "password のバリデーション" do
    it "password が必須であること" do
      user = build(:user, password: nil)
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "password が最低文字数を満たしていること" do
      user = build(:user, password: "short")  # 例えば 5 文字
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("is too short")
    end

    it "password_digest が生成されること" do
      user = create(:user, password: "password123")
      expect(user.password_digest).to be_present
    end
  end

  describe "パスワード認証" do
    it "has_secure_password が正しく動作すること" do
      user = create(:user, password: "password123")

      expect(user.password_digest).to be_present
      expect(user.authenticate("password123")).to be_truthy
      expect(user.authenticate("wrongpass")).to be_falsey
    end
  end
end
