require 'openai'

class Gpt4Service
  def client
    OpenAI::Client.new
  end
end
