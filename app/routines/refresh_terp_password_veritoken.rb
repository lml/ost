class RefreshTerpPasswordVeritoken  

  include Lev::Routine

protected

  def exec(inputs={})
    user = inputs[:user]

    old_veritoken = user.terp_password_veritoken.try(:destroy)

    # if there is no existing veritoken, or there is and it has 
    # been verified, set a new one; otherwise, just extend the 
    # expiration (leaving token and num attempts left intact)

    if old_veritoken.nil? || old_veritoken.verified?
      old_veritoken.try(:destroy)
      user.terp_password_veritoken = Veritoken.numeric(6)
      user.save
      transfer_errors_from(user, {type: :verbatim}, true)
    else
      old_veritoken.extend_expiration!
      transfer_errors_from(old_veritoken, {type: :verbatim}, true)
    end

  end
end