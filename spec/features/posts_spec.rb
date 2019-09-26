require 'rails_helper'
require "bundler/setup"

RSpec.feature "Posts", type: :feature do
  before :each do
    @user = User.create(name: "testuser", email: "user@test.jp", password: "password", password_confirmation: "password")
    @other_user = User.create(name: "testuser2", email: "user2@test.jp", password: "password", password_confirmation: "password")
    @post = @user.posts.create!(title: "test-post", content: "testpost" * 10)
    @closed_post = @user.posts.create!(is_open: false, title: "closedpost", content: "testpost" * 10)
    @other_post = @other_user.posts.create!(title: "test-post2", content: "testpost" * 10)
    @other_closed_post = @other_user.posts.create!(is_open: false, title: "otherclosedpost", content: "testpost" * 10)
  end
  describe 'new' do
    it "with valid input" do
      visit new_post_path # 投稿はログイン必要
      expect(page).to have_selector('.alert-danger', text: 'ログインが必要です')
      fill_in "メールアドレス", with: "user@test.jp"
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      fill_in "タイトル", with: "test-post3"
      fill_in "本文", with: "testpost" * 10
      click_button "投稿"
      expect(page).to have_title(Post.last.title) # 投稿詳細ページへ
    end
  end
  describe 'user_post' do
    before :each do
      visit user_post_path(@user, @post)
      expect(page).to have_link('投稿する(ログイン)') # 非ログイン時コメント不可
      click_on "投稿する(ログイン)"
      fill_in "メールアドレス", with: "user@test.jp"
      fill_in "パスワード", with: "password"
      click_button "ログイン"
    end
    it "have valid links" do
      expect(page).to have_title(@post.title) # ログイン後は直近のURL
      expect(page).to have_link('編集') # 自分の投稿は編集可
      visit user_post_path(@other_user, @other_post)
      expect(page).to have_title(@other_post.title) # 投稿詳細表示を確認
      expect(page).to have_no_link('編集') # 他ユーザの投稿は編集不可
    end
    it "is closed for user but creater" do
      visit user_post_path(@user, @closed_post) # 自分の非公開投稿は閲覧可
      expect(page).to have_title(@closed_post.title)
      visit user_post_path(@user, @other_closed_post) # 他ユーザの非公開は編集不可
      expect(page).to have_selector('li', text: 'MENU') # root_url
    end
  end
  # describe 'edit_post_path', js: true do
  #   before :each do
  #     visit login_path
  #     fill_in "メールアドレス", with: "user@test.jp"
  #     fill_in "パスワード", with: "password"
  #     click_button "ログイン"
  #     visit user_post_path(@user, @post)
  #   end
  #   it "have valid links" do
  #     click_link '編集', href: edit_user_post_path(@user, @post)
  #     expect(page).to have_selector('h1', text: @post.title)
  #     expect(page).to have_link("戻る")
  #   end
  # end

end
