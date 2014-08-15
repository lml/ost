class TerpSignUp
  include Lev::Handler

  paramify :sign_up do
    attribute :username, type: String
    attribute :first_name, type: String
    attribute :last_name, type: String
    attribute :password, type: String
    attribute :password_confirmation, type: String
    attribute :email, type: String
    attribute :email_confirmation, type: String
    attribute :registration_code, type: String
    attribute :student_specified_id, type: String
    attribute :is_auditing, type: boolean
  end

  uses_routine ResetTerpEmailVeritoken

protected

  def authorized?
    caller.nil? || caller.is_anonymous?
  end

  def handle
    section = Section.where(registration_code: sign_up_params.registration_code).first

    fatal_error(message: 'Sorry, we don\'t recognize that code.  Please ask your instructor or check your syllabus.', 
                code: :no_section_for_registration_code, 
                offending_inputs: [:registration_code]) if section.nil?

    user_params = sign_up_params.as_hash(:username, 
                                         :first_name, 
                                         :last_name, 
                                         :password, 
                                         :password_confirmation, 
                                         :email, 
                                         :email_confirmation)
    user_params[:time_zone] = section.klass.time_zone
    
    user = User.new(user_params)

    user.skip_confirmation!
    user.save

    run(ResetTerpEmailVeritoken, user: user)

    transfer_errors_from(user, {type: :verbatim}, true) # do fatal errors

    student = Student.create(:user_id => user.id, 
                             :section_id => section.id, 
                             :is_auditing => sign_up_params.is_auditing || false, 
                             :student_specified_id => sign_up_params.student_specified_id,
                             :terp_only => true)

    transfer_errors_from(student, {type: :verbatim}, true)

    contracts = [FinePrint.get_contract(:general_terms_of_use),
                 FinePrint.get_contract(:privacy_policy)].compact

    contracts.each {|contract| FinePrint.sign_contract(user, contract) }

    options[:user_state].devise_sign_in user
  end

end