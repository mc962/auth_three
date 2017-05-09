class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end

  private

  def require_logged_in
    unless logged_in?
      render json: { errors: ['Not signed in.'] }
    end
  end

  def require_logged_out
    if logged_in?
      # redirect to a root of your choosing if users are in a place that should
      # not be accessible when logged in
    end
  end

  def user_params
    params.require(:user).permit(:username, :password, :email)
  end
end
