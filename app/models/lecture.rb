class Lecture < ApplicationRecord
  belongs_to :teacher, class_name: "User", foreign_key: "user_id"
  has_one :chat, dependent: :destroy
  has_many_attached :photos
  has_one_attached :file
  has_many :notes, dependent: :destroy
  has_many :quizzes, dependent: :destroy, class_name: "Quizz"
  has_many :student_lectures, dependent: :destroy
  has_many :students, through: :student_lectures, source: :user

  after_commit :create_chat, on: :create
  # after_save :call, if: -> { saved_change_to_summary? || saved_change_to_content? }

  def create_chat
    Chat.create(lecture: self)
  end

  def quiz_for_student(user)
    quizzes.where(student: user).last
  end
end
