class AddStatusToQuizz < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzs, :status, :integer
  end
end
