class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :quizz, null: false, foreign_key: true
      t.string :title, null: false
      t.string :correct_answer, null: false

      t.timestamps
    end
  end
end
