class ChatAiService < Gpt4Service
  def call
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: custom_prompt }],
        temperature: 0.9
      }
    )
    response.dig("choices", 0, "message", "content")
  end

  def custom_prompt
    "With this lecture content: #{@lecture.content} and information in the internet that you know regardin the topic of the lecture, answer this message: #{@message.content}. Be creative with your answers but stick to the truth of the information. Keep your answers short."
  end
end
