class RemoveStudentIdFromNotes < ActiveRecord::Migration[7.1]
  def change
    remove_column :notes, :student_id
  end
end
