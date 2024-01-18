class Gpt4Service
  def initialize(lecture, quiz, message = "")
    @message = message
    @lecture = lecture
    @quiz = quiz
  end

  def client
    OpenAI::Client.new
  end
end
