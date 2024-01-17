class CreateQuizService < Gpt4Service
  def call
    prompt = "Create a multiple choice quiz for the lecture summary.
    The quiz should be based on the information given inside the lecture.
    Based on the content and context of this lecture: #{build_quizz_data}.
    you are going to generate a quiz with 10 questions, and 4 possible answers for each question.
    With only one correct answer per question.
    For the format of the quiz, you are going to Use the following hash format: #{quizz_hash_format}.
    This hash format is only meant to be used as a template.
    Do not add any other initial text to the result, it must be the hash format only.
    We will use JSON.parse to parse the result, so make sure it is a valid JSON.
    Questions should be clear"

    begin
      response = client.chat(
        parameters: {
          model: "gpt-4",
          messages: [{ role: "user", content: prompt}],
          temperature: 0.9
          })

      return response if response["choices"].blank?
      response_content = response.dig("choices", 0, "message", "content")
      parsed_content = JSON.parse(response_content)
      parse_quiz_data(parsed_content, quizz)
      return { status: 'success', message: 'Quiz created successfully', quiz: quizz }
    rescue => e
      return { status: 'error', message: e.message }
    end
  end

  private

  def build_score
    return 10.to_s
  end

  def build_quizz_data
    final_data = []
    final_data << @lecture.summary
    final_data << @lecture.title
    final_data.join(" ")
  end

  def quizz_hash_format
    {
      "question": "What is the capital of France?",
      "correct_answer": "C",
      "choices": [
        {"label": "New York", "value": "A"},
        {"label": "London", "value": "B"},
        {"label": "Paris", "value": "C"}
      ]
    }
  end

  def parse_quiz_data(content, quizz)
    content.each do |question_data|
      question_text = question_data["question"]
      correct_answer = question_data["correct_answer"]
      question = Question.create!(quizz: quizz, title: question_text, correct_answer: correct_answer)
      question_data["choices"].each do |choice|
        question.answers.create!(value: choice["value"], content: choice["label"])
      end
    end
  end
end
