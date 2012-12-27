# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module HomeHelper

  class Feature

    NA = -1
    READY = 0
    COMING_SOON = 1

    attr_reader :text, :standard_avail, :research_avail
    
    def initialize(text, standard_avail, research_avail)
      @text = text
      @standard_avail = standard_avail
      @research_avail = research_avail
    end

    def standard_avail_icon
      avail_icon(standard_avail)
    end

    def research_avail_icon
      avail_icon(research_avail)
    end

    def avail_icon(avail)
      case avail
      when NA
        ""
      when READY
        "&#x2713;".html_safe
      when COMING_SOON
        "<span class='coming-soon'>Coming Soon!</span>".html_safe
      end 
    end
  end

  def feature
    Feature
  end

end