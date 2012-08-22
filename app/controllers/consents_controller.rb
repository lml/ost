class ConsentsController < ApplicationController

  before_filter :get_consentable, :only => [:new, :create]

  # def index
  #   raise SecurityTransgression unless present_user.can_list?(Consent)
  #   @consents = Consent.all
  # end
  # 
  # def show
  #   @consent = Consent.find(params[:id])
  #   raise SecurityTransgression unless present_user.can_read?(@consent)
  # end

  def new
    @consent ||= Consent.new({:consent_options => @consentable.options_for_new_consent, 
                              :consentable => @consentable})

    raise SecurityTransgression unless present_user.can_create?(@consent)
  end

  def create
    @consent = Consent.new(params[:consent])
    @consent.consentable = @consentable
    @consent.consent_options = @consentable.options_for_new_consent

    case (params['consent_button'])
    when 'I do not consent'
      @consent.did_consent = false
    when 'I do consent'
      @consent.did_consent = true
    when 'Remind me later'
      @consent.did_consent = nil
    end

    raise SecurityTransgression unless present_user.can_create?(@consent)

    respond_to do |format|
      if @consent.save
        format.html { redirect_to(new_polymorphic_path([@consentable, Consent.new]), :notice => 'Your consent decision was saved.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

protected

  def get_consentable
    @consentable = Student.find(params[:student_id]) if params[:student_id]
  end

end
