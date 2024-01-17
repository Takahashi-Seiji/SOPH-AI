class User < ApplicationRecord
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = ["teacher", "student"].freeze

  # TEACHER
  has_many :lectures, dependent: :destroy
  has_many :students, through: :lectures

  # STUDENT
  has_many :student_lectures
  has_many :quizzs, foreign_key: "user_id", dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :lectures_joined_as_student, through: :student_lectures, source: :lecture
  has_many :reminders, dependent: :destroy


  def teacher?
    role == "teacher"
  end

  def student?
    role == "student"
  end

  def lecture_quiz_averages
    lectures_joined_as_student.map do |lecture|
      { lecture: lecture, average: lecture.average_quiz_grade * 10 }
    end
  end
end
