class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    # check if the user is an admin immediately after authenticating their password.
    if user = User.authenticate_by(auth_params)
      if user.admin?
        # Only admins are allowed to start a new session.
        start_new_session_for user
        redirect_to after_authentication_url
      else
        redirect_to new_session_path, alert: "Access denied. Only admins can sign in."
      end
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  private
    def auth_params
      params.permit(:email_address, :password)
    end
end
