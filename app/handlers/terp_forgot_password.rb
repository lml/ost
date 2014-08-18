class TerpForgotPassword
  include Lev::Handler

  paramify :forgot_password do
    attribute :username, type: String
  end

  uses_routine RefreshTerpPasswordVeritoken

protected

  def authorized?
    caller.nil?
  end

  def handle
    user = User.find_for_database_authentication(username: forgot_password_params.username)

    if user.nil?
      fatal_error(message: 'Sorry we don\'t recognize that username or email.  Mind trying again?' , 
                  code: :invalid_terp_password_reset_username,
                  offending_inputs: [:username])
    end

    locked_error_message = 
      "Your account is now locked because you have exceeded " + 
      "the allowed number of login or password reset attempts.  Wait one " + 
      "hour or <a href='/users/unlock/new' target='_blank'>click here</a>.".html_safe

    if user.access_locked?
      fatal_error(message: locked_error_message,
                  code: :terp_forgot_password_locked)
    end

    veritoken = user.terp_password_veritoken

    if veritoken.nil? || veritoken.verified? || (veritoken.expired? && veritoken.has_attempts_left?)
      run(RefreshTerpPasswordVeritoken, user: user)
    end

    TerpPasswordResetMailer.reset(user).deliver
  end

end