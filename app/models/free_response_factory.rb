
class FreeResponseFactory

  def self.create_from_mail(mail, student_exercise)
    bad_attachment_types = mail.attachments.find_all do |a| 
      FreeResponseUploader::WHITE_LISTED_CONTENT_TYPES.none?(a.content_type)
    end

    raise MailHookHookableError "Attachments of type #{bad_attachment_types.join(', ')} are not allowed" \
      if bad_attachment_types.any?

    body = mail.body.decoded
    
    mail.attachments.each do |attachment|
      begin
        Tempfile.open do |file|
          file.write attachment.body.decoded
          
          free_response = FileFreeResponse.new
          free_response.student_exercise = student_exercise
          free_response.caption = body if !body.blank?
          free_response.attachment = file
          
          free_response.save!
        end
      rescue Exception => e
        raise MailHookHookableError "An unknown error occurred when #{SITE_NAME} tried to " + 
                                    "read the email attachment named '#{attachment.filename}'",
                                    e
      end      
    end    
  end

end