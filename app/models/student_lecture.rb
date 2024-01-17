class StudentLecture < ApplicationRecord
  belongs_to :lecture
  belongs_to :user
  has_many :quizzes, dependent: :destroy
end
