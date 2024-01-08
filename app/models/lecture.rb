class Lecture < ApplicationRecord
  belongs_to :teacher, class_name: "User", foreign_key: "user_id"
  has_one :chat, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :quizzes, dependent: :destroy
  has_many :student_lectures, dependent: :destroy
  has_many :students, through: :student_lectures
end
