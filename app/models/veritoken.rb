
# "VerificationToken" is just too long
class Veritoken < ActiveRecord::Base
  
  attr_accessible :num_attempts_left, :token, :expires_at

  def self.numeric(num_digits, options = {})
    options[:num_attempts] ||= 5
    options[:num_days_active] ||= 5

    instance = Veritoken.new

    begin
      instance.token = "%0#{num_digits}d" % SecureRandom.random_number(10**num_digits)
    end while Veritoken.where(:token => instance.token).any?

    instance.num_attempts_left = options[:num_attempts]
    instance.expires_at = Time.now + options[:num_days_active].days
    instance
  end

  def expired?
    Time.now > expires_at
  end

  def extend_expiration!(num_days_from_now = 5)
    self.update_attributes(expires_at: Time.now + num_days_from_now.days)
  end

  def has_attempts_left?
    num_attempts_left > 0
  end

  def verified?
    token.nil?
  end

  def matches?(otherToken)
    !expired? && has_attempts_left? && (otherToken == token)
  end

  def bad_attempt!
    raise IllegalState if verified?
    self.update_attributes(num_attempts_left: num_attempts_left - 1)
  end

  def verified!
    self.update_attributes(token: nil)
  end
end
