class Quizz < ApplicationRecord
  belongs_to :lecture
  belongs_to :student, class_name: 'User', foreign_key: 'user_id'
  has_many :questions, dependent: :destroy

  enum status: { pending: 1, in_progress: 2, submitted: 3 }
end
