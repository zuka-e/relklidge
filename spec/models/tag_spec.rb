require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'relation' do
    before do
      @user = User.create!(name: "testuser", email: "user@test.jp", password: "password", password_confirmation: "password")
      @post = @user.posts.create!(title: "testpost", content: "testpost" * 10)
      @tag = Tag.create!(name: "testtag")
    end
    context "with user" do
      it "is destroyed when user is destroyed" do
        @favorite_tag = @user.favorite_tags.create(tag: @tag)
        expect(@favorite_tag).to be_valid
        expect{ @user.destroy }.to change(FavoriteTag, :count).by(-1)
      end
    end
    context "with post" do
      it "is destroyed when post is destroyed" do
        @post_tag = @post.post_tags.create(tag: @tag)
        expect(@post_tag).to be_valid
        expect{ @post.destroy }.to change(PostTag, :count).by(-1)
      end
    end
  end
end
