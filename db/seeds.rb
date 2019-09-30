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
categories = %w["民法","最終更新： 令和元年六月十四日公布（令和元年法律第三十四号）改正"]
Category.create!(name:"民法", content: "最終更新： 令和元年六月十四日公布（令和元年法律第三十四号）改正")

# 区分を生成
sections = %w[総則 物権 債権 相続]
sections.each { Section.create!(category_id: 1, name: w) }

# 項目を生成
require "csv"
CSV.foreach("db/items.csv", headers: true) do |row|
  Item.create!(id: row['id'], section_id: row['section_id'], name: row['name'], content: row['content'])
end

# ユーザを生成
User.create!( name: 'Relklidge', email: 'user@test.jp', password: 'password', password_confirmation: 'password')
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
tags = %w[民法 家庭裁判所 制限行為能力者 善意の第三者 催告 錯誤 強迫 詐欺 30年 20年 10年 7年 1年
  保存行為 代理人 取消 無効 追認 破産 財産権 差押え 占有の訴え 住民訴訟 無権代理 制限物権 瑕疵 火事 ]
tags.each { |w| Tag.create!(name: w) }

# 投稿を生成
Post.create!( user_id: 1, title: "非公開投稿", content: "非公開投稿" * 10, is_open: false )
i = 0
User.all.each do |user|
  2.times do |index|
    Post.create!( user_id: user.id,
    title: tags[i] + "について",
    content: "　権利能力とは、権利を取得し、また義務を負担することができる能力のことをいいます。例えば売買契約において、代金を支払って物やサービスを受け取ることができるのもこの権利能力があるためです。
    　そして、この能力を持つ主体は人と呼ばれます。人には、生物としての人（自然人）及び、法律によって権利能力が認められた人（法人）があります。
    　自然人はすべて権利能力を有するとされます。そしてその始まりは出生時（民法3条）、終了は死亡時（通説）となります。ここで、出生の具体的時期については議論が分かれています。判例・通説によれば、胎児が母体から全部露出したときをもって出生とするとされます。つまり、胎児の一部（頭など）が見えているだけの状態では、民法上、出生とは認められないということになります。
    　これには例外があり、不法行為による損害賠償請求（民法721条）、相続（民法886条）、遺贈（民法965条）三つにおいては、既に生まれたものとみなされ、胎児にも権利能力が認められます。ここにも議論がありますが、判例・通説では、胎児が生きて生まれることを条件に権利発生の時期まで遡って権利が認められるとする考え方（停止条件説）が採用されます。つまり胎児の時点で権利能力が存在するわけではないということになります。
    　また外国人においても、法律によって制限のない範囲で同様に権利能力は認められます。（民法3条2項）",
    writing_time: 0,
    is_open: true
  )
  i += 1
  end
end

# 投稿タグを生成
Post.all.each do |post|
  PostTag.create!( post_id: post.id, tag_id: (1..27).to_a.sample )
end
# お気に入りタグを生成
User.all.each do |user|
  FavoriteTag.create!( user_id: user.id, tag_id: (1..27).to_a.sample )
end

# コメントを生成
order = (1..20).to_a.reverse
i = 0
User.all.each do |user|
  Comment.create!( user_id: user.id,
    post_id: order[i],
    content: "外国人の権利能力の制限には例えば、土地に関する権利の享有（外国人土地法1条）、国家賠償（国家賠償法6条）などが採用する相互主義に基づく制限や、知的財産権の享有に関する制限（特許法25条、実用新案法55条3項、意匠法68条3項、商標法77条3項など）などがありますね",
  )
  Like.create!( user_id: user.id,
    post_id: order[i]
  )
  i += 1
end
