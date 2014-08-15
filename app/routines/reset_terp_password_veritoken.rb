class ResetTerpPasswordVeritoken

  include Lev::Routine

protected

  def exec(inputs={})
    user = inputs[:user]

    user.terp_password_veritoken.try(:destroy)
    user.terp_password_veritoken = Veritoken.numeric(6)
    user.save

    transfer_errors_from(user, {type: :verbatim}, true)

    TerpPasswordResetMailer.reset(user).deliver
  end
end