class UserPolicy < ApplicationPolicy
  def create_lecture?
    user.teacher?
  end

  def view_lecture?
    true
  end

  def create_note?
    user.student?
  end

  def create_quiz?
    user.student?
  end

  def start_chat?
    user.student?
  end

  def view_submitted_quizzes?
    user.teacher?
  end
end
