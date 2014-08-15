class ResetTerpEmailVeritoken

  include Lev::Routine

protected

  def exec(inputs={})
    user = inputs[:user]

    user.terp_email_veritoken.try(:destroy)
    user.terp_email_veritoken = Veritoken.numeric(6)
    user.save

    transfer_errors_from(user, {type: :verbatim}, true)

    TerpEmailConfirmationMailer.code(user).deliver
  end
end