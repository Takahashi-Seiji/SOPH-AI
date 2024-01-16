class ReminderPolicy < ApplicationPolicy
  def create?
    user.student?
  end
end
