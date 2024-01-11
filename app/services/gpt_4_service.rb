require 'openai'

class Gpt4Service
  def initialize(client)
    @client = client
  end

  def create_quizz(lecture)
    prompt = "You are a teacher, and you want to create a personalized multiple choice quiz for each of your students.
    Based on the student average score: #{build_score}, and based on the content and context of this lecture: #{build_quizz_data(lecture)}.
    you are going to generate a quiz with 10 questions, and 4 possible answers for each question.
    With only one correct answer per question. Not two, not three, but one correct answer per question.
    For the answer - question format of the quiz, you are going to Use the following hash format: #{quizz_hash_format}.
    Note that this hash format is only meant to be used as a template, and you can change it as you see fit.
    Questions should be as precise, concise and clear as possible"

    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt}],
        temperature: 0.9
        })


    response.dig("choices", 0, "message", "content")
    quizz_data = parse_quiz_data(response)
  end

  private

  def build_score
    return 10.to_s
  end

  def build_quizz_data(lecture)
    final_data = []
    final_data << lecture.content
    final_data << lecture.title
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

  def parse_quiz_data(response, lecture)
    quiz_data = response["choices"][0]["message"]["content"]
    quiz_content = Quizz.create!(lecture: lecture)
    quiz_data.each do |question_data|
      question = Question.create!(content: question_data["question"], lecture: lecture)
      question_data["choices"].each do |choice|
        question.answers.create!(content: choice["label"], correct: choice["value"] == question_data["correct_answer"])
      end
    end
  end
end
