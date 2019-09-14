class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.string :writing_time, default: "00:00:00.00"
      t.boolean :is_open, default: false

      t.timestamps
    end
  end
end
