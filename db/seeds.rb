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
categories = [["憲法","6b479db3c59fb4aaf88f81215b5e303d9d410457d0d112e9d376b5ed27b5"],["民法","0fe69738129f0875194c7f4e482c04e809581fde783f962bfb123c0b3947"]]
categories.each { |w| Category.create!(name: w[0], content: "", image_id: w[1]) }

# 区分を生成
sections1 = %w[基本的人権 平和主義 国民主権]
sections2 = %w[総則 物権 債権 相続]
sections = [sections1, sections2]
i = 0
categories.count.times do |index|
  sections[i].each { |w| Section.create!(category_id: i + 1, name: w) }
  i += 1
end

# 項目を生成
items1_1 = %w[生存権 社会権 参政権]
items1_2 = %w[戦争の放棄]
items1_3 = %w[国会 内閣 最高裁判所]
items2_1 = %w[権利能力 法人 制限行為能力者]
items2_2 = %w[不動産と動産 取得時効 抵当権]
items2_3 = %w[保証債務 連帯債務 弁済]
items2_4 = %w[婚姻 養子 相続]
items = [items1_1, items1_2, items1_3, items2_1 ,items2_2, items2_3, items2_4]
i = 0
categories.count.times do |index|
  sections[index].count.times do
    items[i].each { |w| Item.create!(section_id: i + 1, name: w) }
    i += 1
  end
end

# ユーザを生成
User.create!( name: 'テストユーザ', email: 'user@test.jp', password: 'password', password_confirmation: 'password')
names = %w[Amy Bob Cyan Dim Eif Fena Gon Hon Ion John]
names.each do |w|
  email = "#{(0...8).map{ ('A'..'Z').to_a[rand(26)] }.join}@test.com"
  password = "password"
  is_quit = [false, true]
  User.create!( name: w,
    image_id: "",
    email: email,
    password: password,
    password_confirmation: password,
    is_quit: is_quit.sample
    )
end

# 投稿を生成
Post.create!( user_id: 1, title: "True", content: "True", is_open: true )
User.all.each do |user|
  Post.create!( user_id: user.id,
  title: "title-#{user.id}",
  content: "post_content-#{user.id}" * 50,
  writing_time: 0,
  is_open: false
)
end

# タグを生成
tags = %w[憲法 民法 家庭裁判所 制限行為能力者 善意の第三者 催告 錯誤 強迫 詐欺 保存行為 代理人 取消し 無効 追認 破産 差押え 占有の訴え]
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
