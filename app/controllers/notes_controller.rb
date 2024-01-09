class NotesController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @note = Note.new(note_params)
    @note.user = current_user

    if @note.save
      respond_to do |format|
        format.html { redirect_to lecture_path(@lecture) }
      end
    end
  end

  private

  def note_params
    params.require(:note).permit(:content)
  end
end
