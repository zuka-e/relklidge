class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :section, foreign_key: true
      t.string :name, null: false
      t.text :content

      t.timestamps
    end
  end
end
