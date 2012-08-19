class ResearchController < ApplicationController
  before_filter :authenticate_researcher_or_admin!

  def index
  end
end
