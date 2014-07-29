class ResetTerpConfirmationCode

  include Lev::Routine

protected

  def exec(inputs={})

    user = inputs[:user]

    begin
      terp_confirmation_code = SecureRandom.random_number(1000000)
    end while User.where(:terp_confirmation_code => terp_confirmation_code).any?
    user.terp_confirmation_code = "%06d" % terp_confirmation_code

    user.save

    transfer_errors_from(user, {type: :verbatim}, true)

    TerpConfirmationMailer.code(user).deliver
  end
end