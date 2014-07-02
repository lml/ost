require 'spec_helper'

describe CloneKlass do
  
  before(:each) do
    @course = FactoryGirl.create :course
    @klass = Klass.new
    @klass.save

  end

  context 'smoke test' do
    it 'works' do
      debugger
      debugger
    end
  end


end


      # expect_any_instance_of(AddEmailToUser).not_to receive(:run)
      # expect(EmailAddress.find_by_value('user@example.com')).to be_nil

      # AddEmailToUser.call('user@example.com', user, already_verified: true)

      # email = EmailAddress.find_by_value('user@example.com')
      # expect(email).not_to be_nil
      # expect(email.user).to eq(user)
      # expect(email.verified).to be_true
      # expect(email.confirmation_code).to be_nil