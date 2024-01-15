class Gpt4Service
  def initialize(lecture, message)
    @message = message
    @lecture = lecture
  end

  def client
    OpenAI::Client.new
  end
end
