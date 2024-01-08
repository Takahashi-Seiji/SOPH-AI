class Lecture < ApplicationRecord
  belongs_to :user
  has_one :chat, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_one :quizz, dependent: :destroy
end
