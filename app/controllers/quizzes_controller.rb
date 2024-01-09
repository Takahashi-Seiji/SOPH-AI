class QuizzesController < ApplicationController

  def show
    @quiz = Quiz.find(params[:id])
    authorize current_user, :view_submitted_quizzes?
    # aca iría la logica adicional para mostrar los resultados del quiz
  end
end
