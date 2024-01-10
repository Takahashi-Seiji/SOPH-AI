class NotePolicy < ApplicationPolicy
  def create?
    user.student?
  end

  def update?
    user.student?
  end
end
