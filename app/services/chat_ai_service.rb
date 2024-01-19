class ChatAiService < Gpt4Service
  def initialize(message, lecture)
    @message = message
    @lecture = lecture
  end
  def call
    summary = @lecture.summary
    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: build_messages,
        temperature: 0.9
      }
    )
    response.dig("choices", 0, "message", "content")
  end

  def custom_prompt
    "You are SOPHIA, a super sarcastic but factual assistant to the students, you should greet the students only after the first message from the student. You will have the content of this lecture: #{@lecture.summary}, to help you answer the questions of the students. You can also search the internet for more information. Be creative with your answers but stick to the truth of the information. Keep your answers short, not more than 30 words. You can also ask the students questions regarding the information you have. If the student asks something that is not related to the lecture, you can say: This is not related to the lecture, please ask me something related to the lecture or ask your teacher. Students can ask anything about the previous messages in the conversation, including the messages from other students. If you detect, based on the context of the conversation, that the student is struggling with the lecture, suggest related topics or resources for further study. You should analyze the sentiment of the student and respond accordingly, be empathic and supportive."
  end

  def build_messages
    messages = @lecture.chat.messages.map do |message|
      [{ role: message.role, content: message.content}]
  end
    messages << [{ role: "user", content: @message.content }]
    messages.prepend([{ role: "user", content: custom_prompt }])
    messages.flatten
  end
end
