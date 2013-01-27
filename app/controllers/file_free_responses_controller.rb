class FileFreeResponsesController < ApplicationController

  def view
    @free_response = FreeResponse.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@free_response)
  end
end
