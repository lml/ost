class AdminCloneKlass
  include Lev::Handler

  paramify :clone_klass do
    attribute :klass_id, type: Integer
    attribute :open_date, type: String
    attribute :start_date, type: String
    attribute :end_date, type: String
    attribute :close_date, type: String
    attribute :clone_research_settings, type: boolean
  end

  uses_routine CloneKlass

protected

  def authorized?
    !caller.nil? && caller.is_administrator?
  end

  def handle

    inputs = clone_klass_params.as_hash(:open_date, :start_date, :end_date, :close_date, :clone_research_settings)
    inputs[:klass] = Klass.find(clone_klass_params.klass_id)

    run(CloneKlass, inputs)

    debugger; debugger



    # section = Section.where(registration_code: register_params.registration_code).first

    # fatal_error(message: 'The provided registration code is invalid.', 
    #             code: :no_section_for_registration_code, 
    #             offending_inputs: [:registration_code]) if section.nil?

    # student = Student.create(:user_id => caller.id, 
    #                          :section_id => section.id, 
    #                          :is_auditing => register_params.is_auditing || false, 
    #                          :student_specified_id => register_params.student_specified_id)

    # transfer_errors_from(student, {type: :verbatim}, true)
  end

end