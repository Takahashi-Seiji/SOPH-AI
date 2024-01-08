class AddGradeToQuizz < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzs, :grade, :integer
  end
end
