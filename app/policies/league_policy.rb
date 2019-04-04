class LeaguePolicy < ApplicationPolicy
  def admin?
    return false if user.nil?
    record.memberships.find_by(user_id: user.id, role: 1)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
