
class MailHookNoMatch < StandardError; end

# http://stackoverflow.com/questions/8383576/ruby-re-raise-exception-with-sub-exception
class MailHookHookableError < StandardError
  attr_reader :original
  def initialize(msg, original=nil)
    super(msg)
    @original = original
  end
end