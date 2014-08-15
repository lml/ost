class TerpForgotPassword
  include Lev::Handler

  paramify :forgot_password do
    attribute :username, type: String
  end

  uses_routine ResetTerpPasswordVeritoken

protected

  def authorized?
    caller.nil?
  end

  def handle
    user = User.find_for_database_authentication(username: forgot_password_params.username)

    if user.nil?
      fatal_error(message: 'We can\'t find an account with that username or email.', 
                  code: :invalid_terp_password_reset_username,
                  offending_inputs: [:username])
    end

    run(ResetTerpPasswordVeritoken, user: user)
  end

end