class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper

  helper_method :current_user
  helper_method :round
  helper_method :logged_admin?

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def logged_admin?
    if current_user
      return User.find(session[:user_id]).admin?
    end

    false
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def round(number)
    number_with_precision(number, precision: 3, significant: true, strip_insignificant_zeros: true)
  end
end
