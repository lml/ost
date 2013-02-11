class AnalyticsController < ApplicationController

  def index
    @klass = Klass.find(params[:klass_id])
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :analytics)
  end

end
