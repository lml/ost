class TerpResendConfirmationEmail
  include Lev::Handler

  uses_routine ResetTerpEmailVeritoken

protected

  def authorized?
    !caller.nil? && !caller.is_anonymous? && !caller.terp_email_veritoken.verified?
  end

  def handle
    run(ResetTerpEmailVeritoken, user: caller)
  end

end