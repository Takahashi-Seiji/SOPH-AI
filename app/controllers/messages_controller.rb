class MessagesController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @chat = @lecture.chat
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    @message.user = current_user
    authorize @message
    if @message.save
      create_ai_message
      render json: { message: @message.content, role: @message.role, user: @message.user }
    else
      render "lectures/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def create_ai_message
    content = ChatAiService.new(@message, @lecture).call
    @chat.messages.create!(content: content, role: "assistant", user: current_user)
  end
end
