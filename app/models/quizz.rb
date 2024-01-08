class Quizz < ApplicationRecord
  belongs_to :lecture
  has_many :questions, dependent: :destroy
end
