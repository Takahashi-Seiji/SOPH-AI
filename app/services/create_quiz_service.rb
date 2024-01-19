class CreateQuizService < Gpt4Service
  def call
    prompt = "Create a multiple choice quiz for the next lecture: #{build_quizz_data}.
    For the format of your response, you are going to use the following hash format: #{quizz_hash_format}.
    This hash format is only meant to be used as a template, meaning you should not add any of this questions, just mantain the number of questions and the structure of the JSON you will return. It must be the hash format only.
    We will use JSON.parse to parse the result, so be sure to return a valid json.
    Questions should be clear and concise, you shoudld always generate 10 questions and 4 possible answers for each question. With 1 correct answer and 3 incorrect answers."

    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo-1106",
          response_format: { type: "json_object" },
          messages: [{ role: "user", content: prompt}],
          temperature: 0.9,

      })
      return response if response["choices"].blank?

      response_content = response.dig("choices", 0, "message", "content")
      parsed_content = JSON.parse(response_content)
      parse_quiz_data(parsed_content)
      return { status: 'success', message: 'Quiz created successfully' }

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
    # final_data << @lecture.instructions
    final_data.join(" ")
  end

  def quizz_hash_format
    {
      "question1": {
        "title": "What is the capital of France?",
        "correct_answer": "C",
        "choices": [
          {"label": "New York", "value": "A"},
          {"label": "London", "value": "B"},
          {"label": "Paris", "value": "C"},
          {"label": "Madrid", "value": "D"}
        ]
      },
      "question2": {
        "title": "What is the capital of Spain?",
        "correct_answer": "B",
        "choices": [
          {"label": "Madrid", "value": "A"},
          {"label": "London", "value": "B"},
          {"label": "Paris", "value": "C"},
          {"label": "New York", "value": "D"}
        ]
      },
      "question3": {
        "title": "What is the capital of England?",
        "correct_answer": "B",
        "choices": [
          {"label": "New York", "value": "A"},
          {"label": "London", "value": "B"},
          {"label": "Paris", "value": "C"},
          { "label": "Madrid", "value": "D" }
        ]
      },
      "question4": {
        "title": "What is the capital of USA?",
        "correct_answer": "C",
        "choices": [
          {"label": "New York", "value": "A"},
          {"label": "London", "value": "B"},
          {"label": "Washington", "value": "C"},
          {"label": "Madrid", "value": "D"}
        ]
      },
      "question5": {
        "title": "What is the capital of Germany?",
        "correct_answer": "D",
        "choices": [
          { "label": "New York", "value": "A" },
          { "label": "London", "value": "B" },
          { "label": "Paris", "value": "C" },
          { "label": "Berlin", "value": "D" }
        ]
      },
      "question6": {
        "title": "What is the capital of Italy?",
        "correct_answer": "A",
        "choices": [
          { "label": "Rome", "value": "A" },
          { "label": "London", "value": "B" },
          { "label": "Paris", "value": "C" },
          { "label": "Madrid", "value": "D" }
        ]
      },
      "question7": {
        "title": "What is the capital of Portugal?",
        "correct_answer": "B",
        "choices": [
          { "label": "New York", "value": "A" },
          { "label": "Lisbon", "value": "B" },
          { "label": "Paris", "value": "C" },
          { "label": "Madrid", "value": "D" }
        ]
      },
      "question8": {
        "title": "What is the capital of Brazil?",
        "correct_answer": "C",
        "choices": [
          { "label": "New York", "value": "A" },
          { "label": "London", "value": "B" },
          { "label": "Brasilia", "value": "C" },
          { "label": "Madrid", "value": "D" }
        ]
      },
      "question9": {
        "title": "What is the capital of Argentina?",
        "correct_answer": "D",
        "choices": [
          { "label": "New York", "value": "A" },
          { "label": "London", "value": "B" },
          { "label": "Paris", "value": "C" },
          { "label": "Buenos Aires", "value": "D" }
        ]
      },
      "question10": {
        "title": "What is the capital of Mexico?",
        "correct_answer": "A",
        "choices": [
          { "label": "Mexico City", "value": "A" },
          { "label": "London", "value": "B" },
          { "label": "Paris", "value": "C" },
          { "label": "Madrid", "value": "D" }
        ]
      }
    }.to_json
  end

  def parse_quiz_data(content)
    quiz_data = content.values
    quiz_data.each do |question_data|
      question_text = question_data["title"]
      correct_answer = question_data["correct_answer"]
      question = Question.create!(quizz: @quiz, title: question_text, correct_answer: correct_answer)
      question_data["choices"].each do |choice|
        question.answers.create!(value: choice["value"], content: choice["label"])
      end
    end
  end
end
