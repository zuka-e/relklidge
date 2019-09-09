class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :section, foreign_key: true
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
