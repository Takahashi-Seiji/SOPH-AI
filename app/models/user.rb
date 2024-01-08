class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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
