class Question < ApplicationRecord
  belongs_to :quizz
  has_many :answers, dependent: :destroy

  def correct?
    self.correct_answer == self.answer
  end
end
