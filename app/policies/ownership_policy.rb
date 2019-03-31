class OwnershipPolicy < ApplicationPolicy
  def new?
    league.memberships.where(role: 1).map(&:user).include?(user)
  end

  def league
    record.league
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
