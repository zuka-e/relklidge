class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.references :category, foreign_key: true
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
