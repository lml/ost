class WriteController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]
  
  def index
    redirect_to "mailto:#{params[:to]}@openstaxtutor.org"
  end
end
