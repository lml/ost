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
      fatal_error(message: 'Sorry we don\'t recognize that username or email.  Mind trying again?', 
                  code: :invalid_terp_password_reset_username,
                  offending_inputs: [:username])
    end

    locked_error_message = 
      "Your account is now locked because you have exceeded " + 
      "the allowed number of login or password reset attempts.  Wait one " + 
      "hour or <a href='/users/unlock/new' target='_blank'>click here</a>.".html_safe

    if user.access_locked?
      fatal_error(message: locked_error_message,
                  code: :terp_reset_password_locked)
    end

    veritoken = user.terp_password_veritoken

    if !veritoken.has_attempts_left?
      after_transaction { 
        user.lock_access! 
        veritoken.destroy
        user.terp_password_veritoken = nil
        user.save
      }
      fatal_error(message: locked_error_message,
                  code: :terp_reset_password_no_attempts_left)
    end
    
    if !veritoken.matches?(reset_password_params.reset_code)
      after_transaction { veritoken.bad_attempt! }
      fatal_error(message: 'Sorry, that provided password reset code is invalid or may have expired.  Mind trying again?', 
                  code: :invalid_terp_password_reset_code,
                  offending_inputs: [:reset_code])
    end

    veritoken.verified!

    user.update_attributes(password: reset_password_params.new_password,
                           password_confirmation: reset_password_params.new_password_confirmation)

    transfer_errors_from(user, {type: :verbatim}, true)
  end

end