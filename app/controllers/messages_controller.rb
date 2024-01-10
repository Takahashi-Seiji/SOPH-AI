class MessagesController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @chat = @lecture.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)
    @message.user = current_user
    @message.chat = @chat
    @message.save!
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
