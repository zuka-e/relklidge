# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者を生成
Admin.create!( name: "管理者",
  image_id: "",
  email: "admin@test.jp",
  password: 'password',
  password_confirmation: 'password'
)

# カテゴリを生成
categories = %w[憲法 民法]
categories.each { |w| Category.create!(name: w, content: "") }

# 区分を生成
sections = %w[総則 物権 債権 相続]
sections.each	{ |w| Section.create!( category_id: 1, name: w , content: "") }

# 項目を生成
items1 = %w[権利能力 法人 制限行為能力者]
items2 = %w[不動産と動産 取得時効 抵当権]
items3 = %w[保証債務 連帯債務 弁済]
items4 = %w[婚姻 養子 相続]
items1.each	{ |w| Item.create!(section_id: 1, name: w) }
items2.each	{ |w| Item.create!(section_id: 2, name: w) }
items3.each	{ |w| Item.create!(section_id: 3, name: w) }
items4.each	{ |w| Item.create!(section_id: 4, name: w) }

# ユーザを生成
User.create!( name: 'name', email: 'user@test.jp', password: 'password', password_confirmation: 'password')
names = %w[Amy Bob Cyan Dim Eif Fena Gon Hon Ion John]
names.each do |w|
  email = "#{(0...8).map{ ('A'..'Z').to_a[rand(26)] }.join}@test.com"
  password = "password"
  # is_quit = [false, true]
  User.create!( name: w,
    image_id: "",
    email: email,
    password: password,
    password_confirmation: password,
    is_quit: ""
    )
end

# 投稿を生成
User.all.each do |user|
  Post.create!( user_id: user.id,
  title: "title-#{user.id}",
  content: "post_content-#{user.id}" * 50,
  writing_time: "",
  is_open: ""
)
end

# タグを生成
tags = %w[家庭裁判所 制限行為能力者 善意の第三者 催告 錯誤 強迫 詐欺 保存行為 代理人 取消し 無効 追認 破産 差押え 占有の訴え]
tags.each { |w| Tag.create!(name: w) }

# 投稿タグを生成
Post.all.each do |post|
  post.tags << Tag.find(post.id)
end

# コメントを生成
order = (1..11).to_a.reverse
i = 0
User.all.each do |user|
  Comment.create!( user_id: user.id,
    post_id: order[i],
    title: "title-#{user.id}",
    content: "comment_content-#{user.id}" * 10,
  )
  Like.create!( user_id: user.id,
    post_id: order[i]
  )
  i += 1
end
