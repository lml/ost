
class CatalogController < ApplicationController
  def index
    @courses = Course.all
  end
end
