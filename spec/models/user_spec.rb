require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'registraion' do
    before do
      @user = User.new(name: "testuser", email: "user@test.jp", password: "password", password_confirmation: "password")
    end
    context "name" do
      it "is invalid with empty name" do
        @user.name = " " * 2
        @user.save
        expect(@user.errors[:name]).to include("ユーザ名を入力してください")
      end
      it "is invalid with invalid name format" do
        @user.name = "$" * 2
        @user.save
        expect(@user.errors[:name]).to include("使用できるのは、英数字、アンダーバー(_) のみです")
      end
      it "is invalid without minimum name length" do
        @user.name = "a" * 1
        @user.save
        expect(@user.errors[:name]).to include("ユーザ名は2文字以上、20文字以内で入力してください")
      end
      it "is invalid without maxinum name length" do
        @user.name = "a" * 21
        @user.save
        expect(@user.errors[:name]).to include("ユーザ名は2文字以上、20文字以内で入力してください")
      end
      it "is invalid with non-unique name" do
        @existing_user = User.create(name: "Testuser", email: "exist@test.jp", password: "password", password_confirmation: "password")
        @user.save
        expect(@user.errors[:name]).to include("このユーザ名は既に使用されています")
      end
    end
    context "email" do
      it "is invalid with empty email" do
        @user.email = " "
        @user.save
        expect(@user.errors[:email]).to include("メールアドレスを入力してください")
      end
      it "is invalid with invalid email format" do
        @user.email = "user@test-jp"
        @user.save
        expect(@user.errors[:email]).to include("有効なメールアドレスを入力してください")
      end
      it "is invalid with non-unique email" do
        @existing_user = User.create(name: "existing", email: "User@test.jp", password: "password", password_confirmation: "password")
        @user.save
        expect(@user.errors[:email]).to include("このメールアドレスは既に使用されています")
      end
    end
    context "password" do
      it "is invalid with empty password" do
        @user.password = " "
        @user.save
        expect(@user.errors[:password]).to include("パスワードを入力してください")
      end
      it "is invalid without minimum password length" do
        @user.password = "a" * 7
        @user.save
        expect(@user.errors[:password]).to include("パスワードは8文字以上で入力してください")
      end
      it "is invalid with non-unique email" do
        @user.password = @user.password_confirmation = nil
        @user.save
        expect(@user).not_to be_valid
      end
    end
  end

end
