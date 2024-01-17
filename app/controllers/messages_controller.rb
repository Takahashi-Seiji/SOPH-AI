class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @lecture = @chat.lecture
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    @message.user = current_user
    authorize @message
    if @message.save
      ai_content = create_ai_message
      @chat.messages.create!(content: ai_content, role: "assistant", user: current_user)
      render json: { ai_message: ai_content }
    else
      render "lectures/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :chat_id)
  end

  def create_ai_message
    ChatAiService.new(@message, @lecture).call
  end
end
