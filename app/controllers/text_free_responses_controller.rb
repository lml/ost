class TextFreeResponsesController < ApplicationController

  def preview
    @text = params[:free_response][:content]    
  end
end
