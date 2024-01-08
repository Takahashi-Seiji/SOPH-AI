class Quizz < ApplicationRecord
  belongs_to :lecture
  belongs_to :student, class_name: 'User', foreign_key: 'user_id'
  has_many :questions, dependent: :destroy
end
