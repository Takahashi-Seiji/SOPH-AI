class NotesController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @note = @lecture.notes.new(note_params)
    @note.user = current_user

    if @note.save!
      redirect_to lecture_path(@lecture)
    end
  end

  def update
    @note = Note.find(params[:id])
    if @note.update(note_params)
      redirect_to lecture_path(@note.lecture)
    end
  end

  private

  def note_params
    params.require(:note).permit(:content)
  end
end
