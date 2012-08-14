class WriteController < ApplicationController
  def index
    redirect_to "mailto:#{params[:to]}@openstaxcollege.org"
  end
end
