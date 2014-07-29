class TerpConfirmEmail
  include Lev::Handler

  paramify :confirm do
    attribute :code, type: String
  end

protected

  def authorized?
    !caller.nil? && !caller.is_anonymous? && !caller.terp_confirmed?
  end

  def handle

    if confirm_params.code != caller.terp_confirmation_code    
      fatal_error(message: 'The provided confirmation code is invalid.', 
                  code: :invalid_terp_confirmation_code, 
                  offending_inputs: [:code])
    end

    caller.terp_confirmation_code = nil
    caller.save

    transfer_errors_from(caller, {type: :verbatim}, true)
  end

end