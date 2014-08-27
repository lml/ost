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

    fatal_error(message: 'Sorry, we don\'t recognize that code.  Please ask your instructor or check your syllabus.', 
                code: :no_section_for_registration_code, 
                offending_inputs: [:registration_code]) if section.nil?

    no_matching_assignments = section.klass.learning_plan.assignment_plans.none?{|ap| ap.embed_code == params[:terp_id]}

    fatal_error(message: 'Sorry, that registration code doesn\'t correspond to this Concept Coach.  Please ask your instructor or check your syllabus.', 
                code: :registration_code_does_not_agree_with_embed_code, 
                offending_inputs: [:registration_code]) if no_matching_assignments

    fatal_error(message: 'You have already registered for the class attached to this registration code.',
                code: :already_registered,
                offending_inputs: [:registration_code]) if section.students.any?{|student| student.user_id == caller.id}

    student = Student.create(:user_id => caller.id, 
                             :section_id => section.id, 
                             :is_auditing => register_params.is_auditing || false, 
                             :student_specified_id => register_params.student_specified_id,
                             :terp_only => true)

    transfer_errors_from(student, {type: :verbatim}, true)
  end

end