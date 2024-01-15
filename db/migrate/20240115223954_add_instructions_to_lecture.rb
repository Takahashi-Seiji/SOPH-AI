class AddInstructionsToLecture < ActiveRecord::Migration[7.1]
  def change
    add_column :lectures, :instructions, :text
  end
end
