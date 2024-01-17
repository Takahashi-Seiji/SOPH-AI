class RunGptRequestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    lecture = args.first
    quiz = args.second

    service_response = CreateQuizService.new(lecture).call

    if service_response[:status] == 'success'
      quiz.update!(status: 'created')
    else
      Rails.logger.info "Error: #{service_response[:message]}"
    end
  end
end
