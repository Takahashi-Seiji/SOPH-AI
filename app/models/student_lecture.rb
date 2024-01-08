class StudentLecture < ApplicationRecord
  belongs_to :lecture
  belongs_to :student, class_name: 'Student', foreign_key: 'student_id'
end
