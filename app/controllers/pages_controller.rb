class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :welcome ]

  def home
  end

  def dashboard
    @student = current_user
    @submitted_quizzes = @student.quizzes.where(status: 'submitted')
    @average_score = @submitted_quizzes.average(:score) if @submitted_quizzes.any?

  end

  def welcome
  end
end
