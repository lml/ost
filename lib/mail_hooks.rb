
class MailHookNoMatch < StandardError; end

# http://stackoverflow.com/questions/8383576/ruby-re-raise-exception-with-sub-exception
class MailHookHookableError < StandardError
  attr_reader :original
  def initialize(msg, original=nil)
    super(msg)
    @original = original
  end
end

# class MailHookMessage

#   def to
#     raise AbstractMethodCalled
#   end

#   def to_address
#     raise AbstractMethodCalled
#   end

#   def subject
#     raise AbstractMethodCalled
#   end

#   def to_s
#     "To: #{to}, To Address: #{to_address}, Subject: #{subject}"
#   end

# end

# class CloudMailInJsonMessage < MailHookMessage

#   attr_accessor :data

#   def initialize(data)
#     @data = data
#   end

#   def to
#     @data[:headers][:To]
#   end

#   def to_address
#     extract_address(to)
#   end

#   def extract_address(raw)
#     raw.match(/<(.*)>/)[1]
#   end

#   def subject
#     @data[:headers][:Subject]
#   end

# end