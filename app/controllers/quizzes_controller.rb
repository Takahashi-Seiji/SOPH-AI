class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show,:update]

  def create
    @lecture = Lecture.find(params[:lecture_id])
    student_lecture = StudentLecture.find_by(user: current_user, lecture: @lecture)
    @quiz = Quizz.new(student: current_user, lecture: @lecture, status: 'draft')
    authorize @quiz, :create?
    if @quiz.save
      create_gpt_quiz

    else
      redirect_to lecture_path(@lecture)
    end
  end

  def show
    @quiz = Quizz.find(params[:id])
    @lecture = @quiz.lecture
    #@submitted_quizzes_count = @lecture.quizzes.where(user_id: current_user.id).count

    authorize @quiz, :show?
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@quiz), partial: "lectures/student_quiz", locals: { quiz: @quiz })
      end
      format.html { render partial: "lectures/student_quiz", locals: { quiz: @quiz } }
    end
  end

  def new
    @quiz = Quizz.new
    authorize @quiz, :create?
  end

  def update
    @quiz = Quizz.find(params[:id])
    @student_lecture = StudentLecture.find_by(user: current_user, lecture: @quiz.lecture)
    authorize @quiz, :update?
    return submit_quiz if params["submit_quiz"]

    if submitted || @quiz.update(quiz_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(dom_id(@quiz), partial: "lectures/results", locals: { quiz: @quiz })
        end
        format.html { redirect_to lecture_path(@quiz.lecture) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Quiz could not be submitted, there was an error"
          render turbo_stream: turbo_stream.replace(dom_id(@quiz), partial: "lectures/student_quiz", locals: { quiz: @quiz })
        end
        format.html { render :edit }
      end
    end
  end

  private

  def create_gpt_quiz
    # RunGptRequestJob.perform_later(@lecture, @quiz)
    service_response = CreateQuizService.new(@lecture, @quiz).call
    if service_response[:status] == 'success'
      @quiz.update!(status: 'created')
      render partial: "lectures/student_quiz", locals: { quiz: @quiz, lecture: @lecture }
    else
      Rails.logger.info "Error: #{service_response[:message]}"
      render json: { error: service_response[:message] }, status: :unprocessable_entity
    end
  end

  def submit_quiz
    global_score = 0
    @quiz.questions.each do |question|
      answer = submit_quiz_params[question.id.to_s]
      question.update!(answer: answer)
      global_score += 1 if question.answer == question.correct_answer
    end
    grade = (global_score / @quiz.questions.count.to_f) * 10
    @quiz.update!(status: 'submitted', grade: grade)
    #student_lecture = StudentLecture.find_by(user: current_user, lecture: @quiz.lecture)
    #student_lecture.increment!(:quiz_submissions_count)
    render turbo_stream: turbo_stream.replace("quiz", partial: "lectures/results", locals: { quiz: @quiz, lecture: @quiz.lecture, correct_answers: global_score })
  end

  def quiz_service
    @quiz_service ||= CreateQuizService.new(@lecture)
  end

  def set_quiz
    @quiz = Quizz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:status, :grade)
  end

  def submit_quiz_params
    quiz_question_ids = @quiz.questions.map { |question| question.id.to_s }
    params.require(:answers).permit(quiz_question_ids)
  end
end
