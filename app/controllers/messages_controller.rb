class MessagesController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @chat = @lecture.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)
    @message.user = current_user
    @message.chat = @chat
    @message.save!

    # openai_response = openai_chat_api(@message.content)

    # @chat.messages.create!(content: openai_response['choices'][0]['message']['content'], user: 'OpenAI')

    # respond_to do |format|
    #   format.html { redirect_to lecture_path(@lecture) }
    #   fromat.js
    # end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  # def openai_chat_api(user_message)
  #   openai_endpoint = 'https://api.openai.com/v1/chat/completions'
  #   openai_api_key = ENV['OPENAI_API_KEY']

  #   response = RestClient.post(
  #     openai_endpoint,
  #     { messages: [{ role: 'system', content: 'You are a helpful assistant'}, { role: 'user', content: user_message}]}.to_json,
  #     { Authorization: "Bearer #{openai_api_key}", content_type: :json, accept: :json }
  #   )
  #   JSON.parse(response.body)
  # end
end
