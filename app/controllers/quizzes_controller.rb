class QuizzesController < ApplicationController
  def show
    @quiz = Quiz.find(params[:id])
    authorize @quiz, :view_submitted_quizzes?

    @questions = @quiz.questions
    @student = User.find(params[:student_id])
    @submitted_quizzes = @student.quizzes.where(status: 'submitted')

    @scores = @submitted_quizzes.map { |quiz| calculate_score(quiz) }

    @average_score = @scores.sum / @scores.size.to_f
  end

  def new
    @quiz = Quiz.new
    authorize @quiz, :create?
  end




end
