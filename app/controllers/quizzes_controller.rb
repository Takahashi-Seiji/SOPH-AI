class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update]
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

  def update
    if @quiz.update(quiz_params)
      if params[:commit] == 'Submit Quiz'
        @quiz.submitted!
        @quiz.score = @quiz.calculate_score
        @quiz.save
      end
      redirect_to @quiz, notice: 'Quiz was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:status)
  end
end
