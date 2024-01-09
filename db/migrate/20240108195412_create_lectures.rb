class CreateLectures < ActiveRecord::Migration[7.1]
  def change
    create_table :lectures do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :content
      t.string :shareable_link
      t.date :date
      t.integer :lecture_number

      t.timestamps
    end
  end
end
