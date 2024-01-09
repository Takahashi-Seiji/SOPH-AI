class User < ApplicationRecord
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = ["teacher", "student"].freeze

  # TEACHER
  has_many :lectures, dependent: :destroy

  # STUDENT
  has_many :student_lectures
  has_many :quizzes, dependent: :destroy


  def teacher?
    role == "teacher"
  end

  def student?
    role == "student"
  end
end
