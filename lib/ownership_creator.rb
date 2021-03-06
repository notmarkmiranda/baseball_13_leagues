class OwnershipCreator
  attr_reader :league_token
  attr_reader :params
  attr_reader :user

  def initialize(params, league_token)
    @params = params
    @league_token = league_token
    @user = create_user
  end

  def save
    ownership = league.ownerships.find_or_initialize_by(only_ownership_params.merge({ user_id: user.id }))
    create_membership if ownership.valid?
    return ownership if ownership.save

    false
  end

  private

  def create_membership
    membership = league.memberships.find_or_initialize_by(user: user)
    membership.role = 0 if membership.new_record?
    membership.save
  end

  def create_user
    user = User.find_or_initialize_by(only_user_params)
    set_password(user) if user.new_record?
    # TODO: remove when you set up sendgrid
    user.skip_confirmation!
    user.save!
    user
  end

  def league
    @league ||= League.find_by_token(league_token)
  end

  def only_ownership_params
    params.except('user')
  end

  def only_user_params
    params['user']
  end

  def set_password(user)
    user.password = SecureRandom.hex
  end
end
