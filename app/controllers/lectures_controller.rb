class LecturesController < ApplicationController
  def show
    @lecture = Lecture.find(params[:id])

    redirect_to root_path unless lecture_accessible?
    authorize current_user, :view_lecture?
    setup_lecture_resources

    if current_user.student?
      authorize_student_actions
      create_student_lecture
      create_or_find_note
    end
  end

  def new
    # authorize current_user, :create_lecture?
    @lecture = Lecture.new
  end

  def create
    @lecture = Lecture.new(lecture_params)
    authorize @lecture
    @lecture.teacher = current_user
    @lecture.shareable_link = SecureRandom.hex(10)
    redirect_to lecture_path(@lecture) if @lecture.save
  end

  def edit
    @lecture = Lecture.find(params[:id])
  end

  def update
    @lecture = Lecture.find(params[:id])
    redirect_to lecture_path(@lecture) if @lecture.update(lecture_params)
  end

  def destroy
    @lecture = Lecture.find(params[:id])
    @lecture.destroy
    redirect_to dashboard_path
  end

  private

  def lecture_params
    params.require(:lecture).permit(:title, :content, photos: [])
  end

  def create_student_lecture
    if StudentLecture.exists?(lecture: @lecture, user: current_user)
      flash[:notice] = "You have already joined this lecture!"
    else
      StudentLecture.create(lecture: @lecture, user: current_user)
      flash[:notice] = "You have successfully joined the lecture!"
    end
  end

  def create_or_find_note
    @note = Note.find_by(lecture: @lecture, user: current_user)
  end

  def setup_lecture_resources
    @notes = @lecture.notes
    @chat = @lecture.chat || @lecture.create_chat
    @message = Message.new
  end

  def authorize_student_actions
    authorize current_user, :create_note?
    authorze current_user, :start_chat?
    authorize current_user, :create_quiz?
  end

  def lecture_accessible?
    @lecture.teacher == current_user || @lecture.shareable_link == params[:code] || @lecture.students.include?(current_user)
  end
end
