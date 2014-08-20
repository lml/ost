class TerpChangePassword
  include Lev::Handler

  paramify :change_password do
    attribute :old_password, type: String
    attribute :new_password, type: String
    attribute :new_password_confirmation, type: String
  end

protected

  def authorized?
    !caller.nil? && !caller.is_anonymous?
  end

  def handle

    fatal_error(message: 'Sorry, your old password is incorrect.  Mind trying again?',
                code: :terp_change_password_old_password_incorrect) if !caller.valid_password?(change_password_params.old_password) 

    caller.update_attributes(password: change_password_params.new_password,
                           password_confirmation: change_password_params.new_password_confirmation)

    transfer_errors_from(caller, {type: :verbatim}, true)
  end

end