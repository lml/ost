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

    if no_matching_assignments
      if caller.students.any?{|s| s.terp_only}
        fatal_error(message: 'It looks like this Concept Coach is not assigned to you.  If you think this is an error, please email support@openstaxtutor.org.', 
                    code: :wrong_concept_coach, 
                    offending_inputs: [:registration_code]) 
      else
        fatal_error(message: 'The class you are trying to register for doesn\'t use this Concept Coach.  If you think this is an error, please email support@openstaxtutor.org.', 
                    code: :class_doesnt_have_concept_coach, 
                    offending_inputs: [:registration_code]) 
      end
    end

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