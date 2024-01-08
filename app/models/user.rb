class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :school_users
  has_many :schools, through: :school_users
  # TEACHER
  has_many :lectures, dependent: :destroy

  #STUDENT
  has_many :student_lectures


  def teacher
    role == "teacher"
  end

  def student
    role == "student"
  end
end
