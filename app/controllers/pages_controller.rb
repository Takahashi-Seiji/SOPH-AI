class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :welcome ]

  def home
  end

  def dashboard
    @average_grade = current_user.student_lectures.map(&:lecture).map(&:average_quiz_grade).sum / current_user.student_lectures.count
    # Scope your query to the dates being shown:
  start_date = params.fetch(:start_date, Date.today).to_date

  # For a monthly view:
  @reminders = Reminder.where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  def welcome
  end
end
