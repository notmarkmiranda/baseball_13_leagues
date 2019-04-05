class ApplicationController < ActionController::Base
  include Pundit
  helper_method :require_admin

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  private

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
