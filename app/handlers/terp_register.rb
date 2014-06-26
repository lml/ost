class TerpRegister
  include Lev::Handler

  paramify :register do
    attribute :registration_code, type: String
    attribute :student_specified_id, type: String
    attribute :is_auditing, type: boolean
  end

protected

  def authorized?
    !caller.nil? && !caller.is_anonymous?
  end

  def handle
    section = Section.where(registration_code: register_params.registration_code).first

    fatal_error(message: 'The provided registration code is invalid.', 
                code: :no_section_for_registration_code, 
                offending_inputs: [:registration_code]) if section.nil?

    student = Student.create(:user_id => caller.id, 
                             :section_id => section.id, 
                             :is_auditing => register_params.is_auditing || false, 
                             :student_specified_id => register_params.student_specified_id)

    transfer_errors_from(student, {type: :verbatim}, true)
  end

end