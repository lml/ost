
module Ost
  module Utilities

    def full_section_name(section)
      section.offered_course.course.name + " (" + section.name + ")"
    end

  end
end
