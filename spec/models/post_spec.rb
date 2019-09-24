require 'rails_helper'

RSpec.describe Post, type: :model do

  describe 'new' do
    before do
      @user = User.create!(name: "testuser", email: "user@test.jp", password: "password", password_confirmation: "password")
      @post = @user.posts.create!(title: "testpost", content: "testpost" * 10)
    end
    context "title" do
      it "is invalid with empty title" do
        @post.update(title: " " * 2)
        expect(@post.errors[:title]).to include("タイトルを入力してください")
      end
      it "is invalid without minimum title length" do
        @post.update(title: "")
        expect(@post.errors[:title]).to include("タイトルは1文字以上、30文字以内で入力してください")
      end
      it "is invalid with over maximum title length" do
        @post.update(title: "$" * 31)
        expect(@post.errors[:title]).to include("タイトルは1文字以上、30文字以内で入力してください")
      end
      it "is invalid with non-unique title" do
        @post = @user.posts.create(title: "testpost", content: "existing" * 10)
        expect(@post.errors[:title]).to include("このタイトルは既に使用されています")
      end
    end
    context "content" do
      it "is invalid with empty content" do
        @post.update(content = " " * 2)
        expect(@post.errors[:content]).to include("本文を入力してください")
      end
      it "is invalid with over maximum content length" do
        @post.update(content: "$" * 2001)
        expect(@post.errors[:content]).to include("本文は2文字以上、2000文字以内で入力してください")
      end
    end
  end
  describe 'destroy' do
    before do
      @user = User.create!(name: "testuser", email: "user@test.jp", password: "password", password_confirmation: "password")
      @post = @user.posts.create(title: "testpost", content: "testpost" * 10)
    end
    it "is destroyed when user is destroyed" do
      expect{ @user.destroy }.to change(Post, :count).by(-1)
    end
  end
  describe 'non-disclosed' do
    before do
      @user = User.create!(name: "testuser", email: "user@test.jp", password: "password", password_confirmation: "password")
      @post = @user.posts.create(title: "testpost", content: "testpost" * 10)
    end
    it "is closed when 'is_open' == true" do
      @post.update(is_open: false)
      expect(Post.all).not_to include @post
      expect(Post.unlimited).to include @post
    end

  end

end
