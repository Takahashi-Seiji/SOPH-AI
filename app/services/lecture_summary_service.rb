require "openai"
require "yomu"
require 'pdf-reader'

class LectureSummaryService < Gpt4Service

  def initialize(lecture, pdf_text_content)
    @lecture = lecture
    @pdf_text_content = pdf_text_content
  end

  def call
    begin
      response = client.chat(
        parameters: {
          model: "gpt-4-1106-preview",
          messages: [{ role: "user", content: generate_text }],
          temperature: 0.9
        }
      )
      response.dig("choices", 0, "message", "content")
    rescue => e
      puts e.message
      return "Sorry, we could not summarize your lecture, please try again later."
    end
  end

  def generate_text
    "Hello, SOPHIA, our esteemed instructor for today's lecture on the topic of #{@lecture.title}.
    Today's class delved into the essential aspects of #{@lecture.content}, a subject rich with vital information for our learning journey. We explored various concepts and key points, absorbing the insightful content provided by SOPHIA.

    Additionally, we had the opportunity to analyze the contents of a PDF file related to the lecture. The PDF content, identified as #{@pdf_text_content}, served as a valuable supplement to our understanding. SOPHIA guided us in extracting meaningful insights from this resource.

    Additionally, we have some instructions for you to follow. Please read them carefully: #{@lecture.instructions} and create the summary accordingly.

    Now, as your teacher and guide, my responsibility is to distill this wealth of information into a concise and student-friendly summary. Our goal is to present the core concepts in a way that is easily comprehensible.

    In the first section of our summary, we'll explore the fundamental principles of #{@lecture.content}. This will provide a solid foundation for understanding the broader context and significance of today's lesson.

    Next, we'll delve into the specifics, highlighting key points and insights that emerged during our exploration. This section aims to crystallize the most crucial information from both the lecture and the supplementary PDF.

    Moving forward, we'll examine the practical implications of the acquired knowledge. How can students apply these concepts in real-world scenarios? This analysis will bridge the gap between theory and application, fostering a deeper understanding.

    In the penultimate section, we'll address any potential questions or uncertainties that may have arisen during the lecture. Clarity is our priority, and addressing concerns ensures that each student leaves with a comprehensive understanding of the material.

    Finally, we'll conclude with a summary recap, reinforcing the key takeaways and encouraging further exploration. This structured approach aims to facilitate effective learning and retention.

    Remember, the goal is to create a summary that is not only informative but also engaging and accessible to all students. Let's embark on this summarization journey together!

    The titles for each section should only include the title, not any special characters or numbers."
  end
end
