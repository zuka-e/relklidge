require 'rails_helper'

RSpec.feature "Users", type: :feature do
  before :each do
    @user = User.create(name: "testuser", email: "user@test.jp", password: "password", password_confirmation: "password")
    @other_user = User.create(name: "testuser2", email: "user2@test.jp", password: "password", password_confirmation: "password")
    @post = @user.posts.create!(title: "test-post", content: "testpost" * 10)
    @closed_post = @user.posts.create!(is_open: false, title: "closedpost", content: "testpost" * 10)
    @other_post = @other_user.posts.create!(title: "test-post2", content: "testpost" * 10)
    @other_closed_post = @other_user.posts.create!(is_open: false, title: "otherclosedpost", content: "testpost" * 10)
  end
  describe 'login' do
    before :each do
      visit login_path
    end
    it "with invalid infomation" do
      fill_in "メールアドレス", with: "user@test.jp"
      fill_in "パスワード", with: nil
      click_button "ログイン"
      expect(page).to have_selector('.alert-danger', text: "メールアドレスかパスワードが正しくありません")
    end
    it "with valid infomation" do
      expect(page).to have_content('ログイン') # ヘッダー情報
      fill_in "メールアドレス", with: "user@test.jp"
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      expect(page).to have_content('ログアウト') # ヘッダー情報変化
      expect(page).to have_title(@user.name)
    end
  end
  describe 'edit user' do
    before :each do
      visit edit_user_path(@user) # ログイン要求
      expect(page).to have_selector('.alert-danger', text: 'ログインが必要です')
      fill_in "メールアドレス", with: "user@test.jp"
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      expect(page).to have_title("登録情報変更") # 遷移先は直近のURL
    end
    it "with invalid input" do
      expect(page).to have_field '登録名', with: @user.name
      fill_in "登録名", with: "testuser2"
      expect(page).to have_field 'メールアドレス', with: @user.email
      fill_in "メールアドレス", with: "update@test.jp"
      click_button '登録'
      expect(page).to have_selector('.alert-danger', text:'エラーが存在します')
    end
    it "with valid input" do
      expect(page).to have_field '登録名', with: @user.name
      fill_in "登録名", with: "a" * 2
      expect(page).to have_field 'メールアドレス', with: @user.email
      fill_in "メールアドレス", with: "update@test.jp"
      click_button '登録'
      expect(page).to have_selector('.alert-success', text: '登録情報を更新しました')
    end
  end
  describe 'is_quit' do
    it "have login constraint after quit" do
      visit withdrawal_path(@user) # ユーザ退会
      expect(page).to have_selector('.alert-danger', text: 'ログインが必要です')
      fill_in "メールアドレス", with: "user@test.jp"
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      click_link '退会する'
      expect(User.first.is_quit).to eq("退会済")
      visit user_path(@user) # ログアウトされたことを確認
      expect(page).to have_selector('.alert-danger', text: 'ログインが必要です')
      fill_in "メールアドレス", with: "user@test.jp" # ログインできないことを確認
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      expect(page).to have_selector('.alert-danger', text: "メールアドレスかパスワードが正しくありません")
    end
  end

end
