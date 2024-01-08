class School < ApplicationRecord
  has_many :students, through: :school_user
end
