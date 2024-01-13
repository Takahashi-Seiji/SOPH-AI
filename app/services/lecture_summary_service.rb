require "openai"
require "yomu"
require 'pdf-reader'

class LectureSummaryService < Gpt4Service
  def initialize(lecture)
    @lecture = lecture
    @text = generate_text
  end

  def call
    begin
      response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: @text }],
        temperature: 0.9
      })
      response.dig("choices", 0, "message", "content")
    rescue => e
      return "Sorry, we could not summarize your lecture, please try again later."
    end
  end

 def generate_text
    user_content = "You are a great teacher, so please summarize the following text, being concise and clear, do not change the information, just summarize it for your students:" + @lecture.content

    # file_blob = @lecture.file.blob
    # tmpfile = file_blob.open(tmpdir: Rails.root.join("tmp"), &:read)
    # file_blob.open(tmpdir: Rails.root.join("tmp"), &:read)
    # reader = PDF::Reader.new(StringIO.new(file))
    # reader.pages.each do |page|
    #   puts page.text
    # end
 end
end
