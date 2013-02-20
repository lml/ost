
# Any class that has a mail_hook should only retrieve it via MailHook.get_for(...).
# Such a class must also supply a static create_mail_hook method that creates a new
# hook in a manner appropriate for the holding class.  In general, a class should
# only have one mail hook, but if it happens at times (due to concurrency issues, etc)
# that there are multiple hooks per owner, that's ok, it'll probably just be that 
# only one of them will ever be returned, then they'll all expire anyway.
#
class MailHook < ActiveRecord::Base
  belongs_to :mail_hookable, :polymorphic => true

  attr_accessible :subject, :to_email, :expires_at, 
                  :mail_hookable, :mail_hookable_id, :mail_hookable_type, 
                  :current_num_uses

  before_validation :downcase_conditions
  validates :to_email, :presence => true
  validates :subject, :uniqueness => {:scope => :to_email}

  after_save :destroy_if_overused

  def self.nonexpired
    where{(expires_at == nil) | (expires_at > Time.now)}
  end

  def self.get_for(hookable)
    hook = MailHook.where{mail_hookable_type == hookable.class.name}
                   .where{mail_hookable_id == hookable.id}
                   .nonexpired
                   .last

    if hook.nil?
      hook = hookable.create_mail_hook
    end

    hook
  end

  def self.create_with_random_subject(hookable, options={})
    options[:to_email] ||= 'uploads@openstaxtutor.org'
    options[:expires_at] ||= standard_expiration_time

    # Find a unique random subject / email combination
    begin
      random_subject = Babbler.babble
    end while MailHook.where{subject == random_subject}.where{to_email == options[:to_email]}.any?

    MailHook.create(:mail_hookable => hookable,
                    :to_email => options[:to_email],
                    :subject => random_subject,
                    :expires_at => options[:expires_at])
  end

  # A match doesn't take into account expiration
  def self.matches_for(mail)
    mail_to_addresses, mail_subject = get_mail_fields(mail)
    where{to_email >> mail_to_addresses}.where{subject == mail_subject}
  end

  # A match doesn't take into account expiration
  def matches?(mail)
    mail_to_addresses, mail_subject = MailHook.get_mail_fields(mail)
    mail_subject == subject && mail_to_addresses.include?(to_email)
  end

  def self.process(mail, match_expected=true)
    hooks = matches_for(mail).nonexpired.all

    raise MailHookNoMatch, "Unmatched email: #{mail.inspect}" if hooks.empty? && match_expected

    hooks.each do |hook|
      outcome = hook.process(mail)
    end
  end

  def process(mail)
    raise MailHookNoMatch if !matches?(mail) 
    begin
      mail_hookable.process_hooked_mail(mail)
      self.increment!(:current_num_uses)
    rescue Exception => e
      raise MailHookHookableError.new("An error occurred when a hookable was processing #{mail.inspect}", e)
    end    
  end

  def expired?
    !expires_at.nil? && Time.now > expires_at
  end

  def extend_expiration!
    self.update_attributes({:expires_at => MailHook.standard_expiration_time}) if !expires_at.nil?
  end

  def self.standard_expiration_time
    Time.now + 30.minutes
  end

  def self.destroy_all_expired!
    MailHook.where{expires_at < Time.now}.find_each do |hook|
      hook.destroy
    end
  end

protected

  def self.get_mail_fields(mail)
    to_addresses = [mail.to].flatten.collect{|to| to.downcase}
    # Get rid of non word characters and strip whitespace
    subject = mail.subject.downcase.gsub(/[^a-z\s^A-Z\s]/,"").strip
    [to_addresses, subject]
  end

  def downcase_conditions
    self.subject.downcase!
    self.to_email.downcase!
  end
  
  def destroy_if_overused
    self.destroy if !max_num_uses.nil? && current_num_uses > max_num_uses
  end

end
