class Quizz < ApplicationRecord
  belongs_to :lecture
  belongs_to :student, class_name: 'User', foreign_key: 'user_id'
  has_many :questions, dependent: :destroy

  enum status: { draft: 1, created: 2, in_progress: 3, submitted: 4 }

  def calculate_score
    # Replace this with your scoring logic
    correct_answers = questions.where(correct: true).count
    total_questions = questions.count

    correct_answers.to_f / total_questions * 100
  end

  def correct_answers
    questions.where(correct: true).count
  end
end
