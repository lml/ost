
class MailFactory

  def self.from_cloudmailin_json(json)
    debugger
    mail = Mail.new do
      to      json[:headers][:To]
      subject json[:headers][:Subject]
      text_part do
        body json[:plain]
      end
    end

    json[:attachments].each do |attachment|
      mail.add_file({:filename => attachment[:file_name], :content => attachment[:content]})
      mail.parts.last.content_transfer_encoding = 'base64'
    end

    mail
  end

end

class MailHook < ActiveRecord::Base
  belongs_to :mail_hookable, :polymorphic => true

  attr_accessible :subject, :to_email, :expires_at, :mail_hookable, :mail_hookable_id, :mail_hookable_type, :current_num_uses

  before_validation :downcase_conditions
  validates :to_email, :presence => true
  validates :subject, :uniqueness => {:scope => :to_email}

  after_save :destroy_if_overused

  def self.create_with_random_subject(hookable, options={})
    options[:to_email] ||= 'uploads@openstaxtutor.org'
    options[:expires_at] ||= Time.now + 30.minutes

    # Find a unique random subject / email combination
    begin
      random_subject = Babbler.babble
    end while MailHook.where{subject == random_subject}.where{to_email == options[:to_email]}.any?

    MailHook.create(:mail_hookable => hookable,
                    :to_email => options[:to_email],
                    :subject => random_subject)
  end

  def self.matches_for(mail)
    where{to_email >> my{mail}.to}.where{subject == my{mail}.subject}
  end

  def matches?(mail)
    mail.subject == subject && mail.to.include?(to_email)
  end

  def self.process(mail, match_expected=true)
    Rails.logger.debug("hooked mail: #{mail.inspect}")
    Rails.logger.debug("hooked mail info: #{mail.to_s}")
    hooks = matches_for(mail).all

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

protected

  def downcase_conditions
    self.subject.downcase!
    self.to_email.downcase!
  end
  
  def destroy_if_overused
    self.destroy if !max_num_uses.nil? && current_num_uses > max_num_uses
  end

end
