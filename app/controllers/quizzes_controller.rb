class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show,:update]

  def create
    @lecture = Lecture.find(params[:lecture_id])
    @quiz = Quizz.new(lecture: @lecture, status: 'draft')
    authorize @quiz, :create?

    create_gpt_quizz
  end

  def show
    @quiz = Quizz.find(params[:id])
    authorize @quiz, :view_submitted_quizzes?

    @questions = @quiz.questions
    @student = User.find(params[:student_id])
    @submitted_quizzes = @student.quizzes.where(status: 'submitted')

    @grades = @submitted_quizzes.map { |quiz| calculate_score(quiz) }

    @average_score = @grades.sum / @grades.size.to_f
  end

  def new
    @quiz = Quizz.new
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

  def create_gpt_quizz
    quizz = gpt4_service.create_quizz(@lecture)
    # Use variable quizz to add it to student or lecture, whatever you need.
    # current_user.quizzes.create(lecture: @lecture, status: 'created')
  end

  def gpt4_service
    client = OpenAI::Client.new
    @gpt4_service ||= Gpt4Service.new(client)
  end

  def set_quiz
    @quiz = Quizz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:status, :grade)
  end
end
