class HelpController < ApplicationController

  skip_before_filter :authenticate_user!

  # This class variable maps topic names to partial names.  This is mostly
  # useful when the topic name does not match the partial name.  If 
  # your topic name is not in this hash, the site will use the topic name
  # as the partial name
  @@topic_partial_names = {
    # "some topic name here" => "corresponding partial name here",
  }

  def topic
    @partial_name = @@topic_partial_names[params[:topic_name]] || params[:topic_name]
    @options = params[:options] || {}

    respond_to do |format|
      format.html
      format.js
    end
  end
  
end
