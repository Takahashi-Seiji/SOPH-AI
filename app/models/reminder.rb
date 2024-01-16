class Reminder < ApplicationRecord
  belongs_to :user

  default_scope { order(:start_time) }

  def time
    start_time.strftime('%I:%M %p')
  end
end
