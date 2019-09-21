# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者を生成
Admin.create!( name: "Admin",
  image_id: "",
  email: "admin@test.jp",
  password: 'password',
  password_confirmation: 'password'
)

# カテゴリを生成
categories = [
  ["憲法","b73dcd1c333c34956a7b3921d11e3d207bde521981d8c0a9d8f62be0c08a","民定憲法として1946年（昭和21年）11月3日公布、1947年（昭和22年）5月3日施行"],
  ["民法","c45e4c4e3b9a2318a8b553e8753f6d4c4ffe60d98b5532ee62eb63270ce2","最終更新： 令和元年六月十四日公布（令和元年法律第三十四号）改正"]
]
categories.each { |w| Category.create!(name: w[0], content: w[2], image_id: w[1]) }

# 区分を生成
sections1 = %w[基本的人権 平和主義 国民主権]
sections2 = %w[総則 物権 債権 相続]
sections = [sections1, sections2]
i = 0
categories.count.times do |index|
  sections[i].each do |w|
    Section.create!(
      category_id: i + 1,
      name: w,
      content: "占有の訴えは本権の訴えを妨げず、また、本権の訴えは占有の訴えを妨げない。\n
      占有の訴えについては、本権に関する理由に基づいて裁判をすることができない。"
    )
    end
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
User.create!( name: '管理者', email: 'user@test.jp', password: 'password', password_confirmation: 'password')
names = %w[Amy Bob Cyan Dim Eif Fena Gon Hon Ion John]
names.each do |w|
  email = "#{(0...8).map{ ('A'..'Z').to_a[rand(26)] }.join}@test.com"
  password = "password"
  User.create!( name: w,
    image_id: "",
    email: email,
    password: password,
    password_confirmation: password,
    is_quit: "利用中"
    )
end

# タグを生成
tags = %w[憲法 民法 家庭裁判所 制限行為能力者 善意の第三者 催告 錯誤 強迫 詐欺 譲渡禁止特約
  保存行為 代理人 取消し 無効 追認 破産 差押え 占有の訴え 住民訴訟 無権代理 制限物権]
tags.each { |w| Tag.create!(name: w) }

# 投稿を生成
Post.create!( user_id: 1, title: "非公開投稿", content: "非公開" * 10, is_open: false )
User.all.each do |user|
  2.times do |index|
    Post.create!( user_id: user.id,
    title: tags.sample,
    content: "所有者は、法令の制限内において、自由にその所有物の使用、収益及び処分をする権利を有する。" * 30,
    writing_time: 0,
    is_open: true
  )
  end
end

# 投稿タグを生成
Post.all.each do |post|
  PostTag.create!( post_id: post.id, tag_id: (1..20).to_a.sample )
end
# お気に入りタグを生成
User.all.each do |user|
  FavoriteTag.create!( user_id: user.id, tag_id: (1..20).to_a.sample )
end

# コメントを生成
order = (1..11).to_a.reverse
i = 0
User.all.each do |user|
  Comment.create!( user_id: user.id,
    post_id: order[i],
    content: "土地の所有権は、法令の制限内において、その土地の上下に及ぶ。" * 2,
  )
  Like.create!( user_id: user.id,
    post_id: order[i]
  )
  i += 1
end
