class TerpResendConfirmationEmail
  include Lev::Handler

  uses_routine ResetTerpConfirmationCode

protected

  def authorized?
    !caller.nil? && !caller.is_anonymous? && !caller.terp_confirmed?
  end

  def handle
    run(ResetTerpConfirmationCode, user: caller)
  end

end