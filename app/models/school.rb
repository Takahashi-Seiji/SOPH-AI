class School < ApplicationRecord
  has_many :school_users
  has_many :users, through: :school_users, source: :user

  scope :students, -> { users.where(role: "student") }
  scope :teachers, -> { users.where(role: "teacher") }
end
