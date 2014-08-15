class TerpResetPassword
  include Lev::Handler

  paramify :reset_password do
    attribute :username, type: String
    attribute :reset_code, type: String
    attribute :new_password, type: String
    attribute :new_password_confirmation, type: String
  end

protected

  def authorized?
    caller.nil?
  end

  def handle
    user = User.find_for_database_authentication(username: reset_password_params.username)

    if user.nil?
      fatal_error(message: 'We can\'t find an account with that username or email.', 
                  code: :invalid_terp_password_reset_username,
                  offending_inputs: [:username])
    end

    veritoken = user.terp_password_veritoken
    
    if !veritoken.matches?(reset_password_params.reset_code)
      after_transaction { veritoken.bad_attempt! }
      fatal_error(message: 'The provided password reset code is invalid or may have expired.', 
                  code: :invalid_terp_password_reset_code,
                  offending_inputs: [:reset_code])
    end

    veritoken.verified!

    user.update_attributes(password: reset_password_params.new_password,
                           password_confirmation: reset_password_params.new_password_confirmation)

    transfer_errors_from(user, {type: :verbatim}, true)
  end

end