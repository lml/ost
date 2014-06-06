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

protected

  def authorized?
    caller.nil? || caller.is_anonymous?
  end

  def handle
    section = Section.where(registration_code: sign_up_params.registration_code).first

    fatal_error(message: 'The provided registration code is invalid.', 
                code: :no_section_for_registration_code, 
                offending_inputs: [:registration_code]) if section.nil?

    user = User.new(sign_up_params.as_hash(:username, 
                                           :first_name, 
                                           :last_name, 
                                           :password, 
                                           :password_confirmation, 
                                           :email, 
                                           :email_confirmation))
    user.save

    user.confirm!

    transfer_errors_from(user, {type: :verbatim}, true) # do fatal errors

    student = Student.create(:user_id => user.id, 
                             :section_id => section.id, 
                             :is_auditing => sign_up_params.is_auditing, 
                             :student_specified_id => sign_up_params.student_specified_id)

    transfer_errors_from(student, {type: :verbatim}, true)

    contracts = [FinePrint.get_contract(:general_terms_of_use),
                 FinePrint.get_contract(:privacy_policy)].compact

    contracts.each {|contract| FinePrint.sign_contract(user, contract) }
  end

end