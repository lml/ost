
class FreeResponseFactory

  def self.create_from_mail(mail, student_exercise)
    mail.attachments.any? ? 
      create_file_free_response_from_mail(mail, student_exercise) :
      create_text_free_response_from_mail(mail, student_exercise)
  end

  def self.create_file_free_response_from_mail(mail, student_exercise)
    bad_attachment_types = mail.attachments.find_all do |a| 
      FreeResponseUploader::WHITE_LISTED_CONTENT_TYPES.none?{|wlct| a.content_type.starts_with?(wlct)}
    end

    raise IllegalArgument, "Attachments of type #{bad_attachment_types.join(', ')} are not allowed" \
      if bad_attachment_types.any?

    body = mail.text_part.body.decoded
    
    mail.attachments.each do |attachment|
      extension = File.extname(attachment.filename)
      begin
        Tempfile.open(['free_response',extension]) do |file|
          debugger
          file.binmode
          file.write Base64.decode64(attachment.body.decoded)
          
          free_response = FileFreeResponse.new
          free_response.filename_override = attachment.filename
          free_response.student_exercise = student_exercise
          free_response.content = body if !body.blank? # caption
          free_response.attachment = file
          
          free_response.save!
        end
      rescue Exception => e
        msg = "An unknown error occurred when #{SITE_NAME} tried to " + 
              "read the email attachment named '#{attachment.filename}'.  Exception: #{e.inspect}"
        Rails.logger.error(msg)
        raise
      end      
    end    
  end

  def self.create_text_free_response_from_mail(mail, student_exercise)
    response = TextFreeResponse.new(:student_exercise_id => student_exercise.id,
                                    :content => mail.text_part.body.decoded)
    response.save!
  end

end