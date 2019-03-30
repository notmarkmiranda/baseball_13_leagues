class OwnershipCreator
  attr_reader :league_id
  attr_reader :params
  attr_reader :user

  def initialize(params, league_id)
    @params = params
    @league_id = league_id
    @user = create_user
  end

  def save
    ownership = league.ownerships.new(only_ownership_params.merge({ user_id: user.id }))
    return ownership if ownership.save

    false
  end

  private

  def create_user
    user = User.find_or_initialize_by(only_user_params)
    set_password(user) if user.new_record?
    user.save!
    user
  end

  def league
    @league ||= League.find(league_id)
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
