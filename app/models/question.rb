class Question < ApplicationRecord
  belongs_to :quizz
  has_many :answers, dependent: :destroy
end
