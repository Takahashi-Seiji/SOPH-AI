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
    authorize current_user, :create_lecture?
    @lecture = Lecture.new
  end

  def create
    @lecture = Lecture.new(lecture_params)
    authorize @lecture
    @lecture.teacher = current_user
    @lecture.shareable_link = SecureRandom.hex(10)

    respond_to do |format|
      if @lecture.save
        summary = handle_openai_content_generation(@lecture.file) if @lecture.file.attached?
        @lecture.update!(summary: summary)
        format.html { redirect_to lecture_path(@lecture) }
      end
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

  def create_student_lecture
    if StudentLecture.exists?(lecture: @lecture, user: current_user)
      flash[:notice] = "You have already joined this lecture!"
    else
      StudentLecture.create(lecture: @lecture, user: current_user)
      flash[:notice] = "You have successfully joined the lecture!"
    end
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

  def file_exists?(attached_file)
    attached_file.attachment&.blob && attached_file.attachment.blob.service.exist?(attached_file.attachment.key)
  end

  def retrieve_pdf_text_content(attached_file)
    file_path = Rails.root.join("tmp", attached_file.filename.to_s)
    File.binwrite(file_path, attached_file.download)
    reader = PDF::Reader.new(file_path)
    pdf_text_content = reader.pages.first(5).map(&:text).join("\n")
    File.delete(file_path) if File.exist?(file_path)
    pdf_text_content
  end

  def handle_openai_content_generation(attached_file)
    if file_exists?(attached_file)
      pdf_text_content = retrieve_pdf_text_content(attached_file)
      openai_request = openai_request(pdf_text_content)
    else
      Rails.logger.info("File does not exist")
    end
  end

  def openai_request(pdf_text_content)
    summary = LectureSummaryService.new(@lecture, pdf_text_content).call
  end
end
