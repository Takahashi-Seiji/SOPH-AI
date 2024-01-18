class ReminderPolicy < ApplicationPolicy
  def create?
    user.student? || user.teacher?
  end
end
