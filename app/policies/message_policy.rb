class MessagePolicy < ApplicationPolicy
  def create?
    user.student?
  end
end
