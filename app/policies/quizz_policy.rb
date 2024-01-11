class QuizzPolicy < ApplicationPolicy
  def create?
    user.student?
  end

  def update?
    user.student?
  end

  def view_submitted_quizzes?
    user.student? || user.teacher?
  end
end
