class Chat < ApplicationRecord
  belongs_to :lecture
  has_many :messages, dependent: :destroy
end
