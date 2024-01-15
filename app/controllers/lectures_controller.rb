class LecturesController < ApplicationController
  def show
    @lecture = Lecture.find(params[:id])
    @submitted_quizzes_count = @lecture.quizzes.where(user_id: current_user.id).count
    redirect_to root_path unless lecture_accessible?
    authorize current_user, :view_lecture?
    setup_lecture_resources

    if current_user.student?
      authorize_student_actions
      create_or_find_note
      @student_lecture = StudentLecture.find_by(lecture: @lecture, user: current_user)
    end
  end

  def new
    authorize current_user, :create_lecture?
    @lecture = Lecture.new
  end

  def create
    @lecture = Lecture.new(lecture_params)
    authorize @lecture
    @lecture.teacher = current_user
    @lecture.shareable_link = SecureRandom.hex(10)
    if @lecture.save
      summary = LectureSummaryService.new(@lecture).call
      @lecture.update!(summary: summary)
      redirect_to lecture_path(@lecture)
    end
  end

  def edit
    @lecture = Lecture.find(params[:id])
  end

  def update
    @lecture = Lecture.find(params[:id])
    authorize @lecture
    redirect_to lecture_path(@lecture) if @lecture.update(lecture_params)
  end

  def destroy
    @lecture = Lecture.find(params[:id])
    @lecture.destroy
    redirect_to dashboard_path
    authorize @lecture
  end

  private

  def lecture_params
    params.require(:lecture).permit(:title, :summary, :content, {photos: []}, :file)
  end

  def create_or_find_note
    @note = Note.find_or_initialize_by(lecture: @lecture, user: current_user)
  end

  def setup_lecture_resources
    @notes = @lecture.notes
    @chat = @lecture.chat || @lecture.create_chat
    @message = Message.new
  end

  def authorize_student_actions
    authorize current_user, :create_note?
    authorize current_user, :start_chat?
    authorize current_user, :create_quiz?
  end

  def lecture_accessible?
    @lecture.teacher == current_user || @lecture.shareable_link == params[:code] || @lecture.students.include?(current_user)
  end
end
