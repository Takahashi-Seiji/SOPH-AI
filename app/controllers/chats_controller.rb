class ChatsController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @chat = @lecture.chats.new
    authorize @message

    raise
    if @chat.save!
      create_ai_message(@message, @lecture)
      redirect_to lecture_path(@lecture)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
