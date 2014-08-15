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
    
    if !user.terp_password_veritoken.verify!(reset_password_params.reset_code)
      nonfatal_error(message: 'The provided password reset code is invalid or may have expired.', 
                  code: :invalid_terp_password_reset_code,
                  offending_inputs: [:reset_code])
      return # don't do a fatal error because that rollsback the decrement of the veritoken num_attempts_left
    end

    user.update_attributes(password: reset_password_params.new_password,
                           password_confirmation: reset_password_params.new_password_confirmation)

    transfer_errors_from(user, {type: :verbatim}, true)
  end

end