
module Ost
  module Utilities

    def full_section_name(section)
      section.klass.course.name + " (" + section.name + ")"
    end

  end
end
