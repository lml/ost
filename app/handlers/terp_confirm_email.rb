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

    veritoken = caller.terp_email_veritoken

    if !veritoken.matches?(confirm_params.code)
      after_transaction { veritoken.bad_attempt! }
      fatal_error(message: 'The provided confirmation code is invalid.', 
                  code: :invalid_terp_confirmation_code, 
                  offending_inputs: [:code])
    end

    veritoken.verified!

    transfer_errors_from(caller, {type: :verbatim}, true)
  end

end