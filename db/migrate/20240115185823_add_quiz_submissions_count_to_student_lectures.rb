class AddQuizSubmissionsCountToStudentLectures < ActiveRecord::Migration[7.1]
  def change
    add_column :student_lectures, :quiz_submissions_count, :integer, default: 0
  end
end
