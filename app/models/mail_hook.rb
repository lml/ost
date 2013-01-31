class MailHookNoMatches < StandardError; end

# http://stackoverflow.com/questions/8383576/ruby-re-raise-exception-with-sub-exception
class MailHookHookableError < StandardError
  attr_reader :original
  def initialize(msg, original=nil);
    super(msg);
    @original = original;
  end
end

class MailHook < ActiveRecord::Base
  belongs_to :mail_hookable, :polymorphic => true

  attr_accessible :subject, :to_email, :expires_at, :mail_hookable_id, :mail_hookable_type, :current_num_uses

  before_validation :downcase_conditions
  validates :to_email, :presence => true
  validates :subject, :uniqueness => {:scope => :to_email}

  after_save :destroy_if_overused

  # require 'enum'
  
  # class Outcome < Enum
  #   SUCCESS = 1
  #   NO_MATCHES = 2
  #   ERROR = 3 
  # end

  def self.matches_for(mail)
    where{to == my{mail}.to}.where{subject == my{mail}.subject}
  end

  def matches?(mail)
    mail.subject == subject && mail.to == to_email
  end

  def self.process(mail, match_expected=true)
    hooks = matches_for(mail).all

    raise MailHookNoMatches "Unmatched email: #{mail.inspect}" if hooks.empty? && match_expected

    hooks.each do |hook|
      outcome = hook.process(mail)
    end
  end

  def process(mail)
    return if !matches?(mail) 
    begin
      mail_hookable.process_hooked_mail(mail)
      self.increment!(:current_num_uses)
    rescue Exception => e
      raise MailHookHookableError.new("An error occurred when a hookable was processing #{mail.inspect}", e)
    end    
  end

protected

  def downcase_conditions
    self.subject.downcase!
    self.to_email.downcase!
  end
  
  def destroy_if_overused
    self.destroy if !max_num_uses.nil? && current_num_uses > max_num_uses
  end

end
