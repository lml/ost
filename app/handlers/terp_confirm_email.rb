class TerpConfirmEmail
  include Lev::Handler

  paramify :confirm do
    attribute :code, type: String
  end

protected

  def authorized?
    !caller.nil? && !caller.is_anonymous? && !caller.terp_email_veritoken.verified?
  end

  def handle

    if !caller.terp_email_veritoken.verify!(confirm_params.code)
      fatal_error(message: 'The provided confirmation code is invalid.', 
                  code: :invalid_terp_confirmation_code, 
                  offending_inputs: [:code])
    end

    transfer_errors_from(caller, {type: :verbatim}, true)
  end

end