
module Ost
  module Utilities

    def full_section_name(section)
      section.course.name + " (" + section.title + ")"
    end

  end
end
