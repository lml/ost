
class FileWrapper
  def initialize(file, name)
    @file = file
    @name = name
  end

  def path
    @name
  end

  def method_missing(name, *args)
    @file.send(name, args)
  end
end


class FreeResponseFactory

  def self.create_from_mail(mail, student_exercise)
    bad_attachment_types = mail.attachments.find_all do |a| 
      FreeResponseUploader::WHITE_LISTED_CONTENT_TYPES.none?{|wlct| a.content_type.starts_with?(wlct)}
    end

    raise MailHookHookableError, "Attachments of type #{bad_attachment_types.join(', ')} are not allowed" \
      if bad_attachment_types.any?

    body = mail.text_part.body
    
    mail.attachments.each do |attachment|
      begin
        Tempfile.open(['free_response','.jpg']) do |file|
          debugger
          file.binmode
          file.write Base64.decode64(attachment.body.decoded)
          
          free_response = FileFreeResponse.new
          free_response.student_exercise = student_exercise
          free_response.content = body if !body.blank? # caption
          # free_response.attachment = FileWrapper.new(file, attachment.filename)
          free_response.attachment = file
          
          free_response.save!
        end
      rescue Exception => e
        msg = "An unknown error occurred when #{SITE_NAME} tried to " + 
              "read the email attachment named '#{attachment.filename}'.  Exception: #{e.inspect}"
        Rails.logger.error(msg)
        debugger
        raise MailHookHookableError, msg
      end      
    end    
  end

end