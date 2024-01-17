class Reminder < ApplicationRecord
  belongs_to :user

  validates :date, presence: true

  default_scope { order(:start_time) }

  def time
    start_time.strftime('%I:%M %p')
  end
end
