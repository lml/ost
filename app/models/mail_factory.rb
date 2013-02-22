
class MailFactory

  # Creates a mail object given json from cloudmailin.com
  def self.from_cloudmailin_json(json)
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