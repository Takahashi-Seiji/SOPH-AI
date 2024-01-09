class LecturesController < ApplicationController
  def show
    @lecture = Lecture.find(params[:id])
    redirect_to root_path unless lecture_accessible?

    create_student_lecture if current_user.student?
  end

  def new
    @lecture = Lecture.new
  end

  def create
    @lecture = Lecture.new(lecture_params)
    @lecture.teacher = current_user
    @lecture.shareable_link = SecureRandom.hex(10)
    if @lecture.save
      redirect_to lecture_path(@lecture)
    end
  end

  private

  def lecture_params
    params.require(:lecture).permit(:title, :content)
  end

  def create_student_lecture
    StudentLecture.create(lecture: @lecture, user: current_user)
    flash[:notice] = "You have successfully joined the lecture!"
  end

  def lecture_accessible?
    @lecture.teacher == current_user || @lecture.shareable_link == params[:code] || @lecture.students.include?(current_user)
  end
end
