class QuizzPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.teacher?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def create?
    user.student?
  end

  def show?
    true
  end

  def update?
    user.student?
  end

  def view_submitted_quizzes?
    user.student? || user.teacher?
  end
end
