class LecturesController < ApplicationController
  def show
    @lecture = Lecture.find(params[:id])

    redirect_to root_path unless lecture_accessible?
    authorize current_user, :view_lecture?

    @notes = @lecture.notes
    @chat = @lecture.chat || @lecture.create_chat
    if current_user.student?
      authorize current_user, :create_note?
      authorize current_user, :start_chat?
      authorize current_user, :create_quiz?
      @note = Note.new
      create_student_lecture
      @note = Note.find_or_initialize_by(user: current_user, lecture: @lecture)
    end
  end

  def new
    @lecture = Lecture.new
    authorize current_user, :create_lecture?
  end

  def create
    @lecture = Lecture.new(lecture_params)
    authorize @lecture
    @lecture.teacher = current_user
    @lecture.shareable_link = SecureRandom.hex(10)
    if @lecture.save
      redirect_to lecture_path(@lecture)
    end
  end

  def edit
    @lecture = Lecture.find(params[:id])
  end

  def update
    @lecture = Lecture.find(params[:id])
    if @lecture.update(lecture_params)
      redirect_to lecture_path(@lecture)
    end
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
    StudentLecture.create(lecture: @lecture, user: current_user)
    flash[:notice] = "You have successfully joined the lecture!"
  end

  def lecture_accessible?
    @lecture.teacher == current_user || @lecture.shareable_link == params[:code] || @lecture.students.include?(current_user)
  end
end
