class ChatsController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @chat = @lecture.chats.new
    @message = @chat.messages.new(message_params)

    @chat.save!
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
