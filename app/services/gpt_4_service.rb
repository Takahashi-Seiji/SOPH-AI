class Gpt4Service
  def initialize(lecture)
    @client = OpenAI::Client.new
  end
end
