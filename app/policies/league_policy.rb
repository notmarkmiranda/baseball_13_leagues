class LeaguePolicy < ApplicationPolicy
  def admin?
    record.memberships.find_by(user_id: user.id, role: 1)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
