class Gpt4Service
  def initialize(message, lecture)
    @client = OpenAI::Client.new
    @message = message
    @lecture = lecture
  end
end
