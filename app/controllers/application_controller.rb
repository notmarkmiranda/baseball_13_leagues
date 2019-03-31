class ApplicationController < ActionController::Base
  include Pundit
  helper_method :require_admin

  private

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
