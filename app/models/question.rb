class Question < ApplicationRecord
  belongs_to :quizz
  has_many :answers, dependent: :destroy

  def correct?
    self.correct_answer == self.answer
  end

  def correct_answer_value
    answers.find_by(value: correct_answer)&.value
  end

  def correct_answer_label
    answers.find_by(value: correct_answer)&.content
  end

end
