##
## Db-manipulation related
##
module Db
  def DbUniverse
    @db_current_courses       = []
    @db_current_educators     = []
    @db_current_instructors   = []
    @db_current_klasses       = []
    @db_current_sections      = []
    @db_current_students      = []
    @db_current_organizations = []
    @db_current_users         = []

    yield if block_given?
  end

  def DbCofUser(options={})
    options ||= { }

    if options[:existing]
      user = User.where{ username == options[:existing] }.first
    elsif @db_current_users.last
      user = @db_current_users.last
    else
      attrs = FactoryGirl.attributes_for(:user)
      attrs[:first_name]        = options[:first_name]  if options[:first_name]
      attrs[:last_name]         = options[:last_name]   if options[:last_name]
      attrs[:username]          = options[:username]    if options[:username]
      attrs[:is_administrator]  = options[:is_admin]    if options[:is_admin]
      user = FactoryGirl.create(:user, attrs)
    end

    if block_given?
      @db_current_users.push user
      yield
      @db_current_users.pop
    end

    user
  end

  def DbCofOrganization(options={})
    options ||= { }

    if options[:existing]
      organization = Organization.where{ name == options[:existing] }.first
    elsif @db_current_organizations.last
      organization = @db_current_organizations.last
    else
      attrs = FactoryGirl.attributes_for(:organization)
      attrs[:name] = options[:name] if options[:name]
      organization = FactoryGirl.create(:organization, attrs)
    end

    if block_given?
      @db_current_organizations.push organization
      yield
      @db_current_organizations.pop
    end

    organization
  end

  def DbCofCourse(options={})
    options ||= { }

    if options[:existing]
      course = Course.where{ name == options[:existing] }
    elsif @db_current_courses.last
      course = @db_current_courses.last
    else
      attrs = FactoryGirl.attributes_for(:course)
      attrs[:name]         = options[:name] if options[:name]
      attrs[:organization] = DbCofOrganization(options)
      course = FactoryGirl.create(:course, attrs)
    end

    if block_given?
      @db_current_courses.push course
      yield
      @db_current_courses.pop
    end

    course
  end

  def DbCofInstructor(options={})
    options ||= { }

    attrs = FactoryGirl.attributes_for(:course_instructor)
    attrs[:user]   = DbCofUser(options[:for_user])
    attrs[:course] = DbCofCourse(options[:for_course])
    instructor = FactoryGirl.create(:course_instructor, attrs)

    if block_given?
      @db_current_instructors.push instructor
      yield
      @db_current_instructors.pop
    end

    instructor
  end

  def DbCofClass(options={})
    options ||= { }

    if options[:existing]
      klass = Klass.where{ course.name == options[:existing] }.first
    elsif @db_current_klasses.last
      klass = @db_current_klasses.last
    else
      attrs = FactoryGirl.attributes_for(:klass)
      attrs[:course]  = DbCofCourse(options[:for_course])
      if options[:for_creator]
        attrs[:creator] = DbCofUser(options[:for_creator])
      elsif @db_current_instructors.last
        attrs[:creator] = @db_current_instructors.last.user
      end
      klass = FactoryGirl.create(:klass, attrs)
      klass.sections.first.name = "DELETE THIS SECTION"
      klass.sections.first.save!
    end

    if block_given?
      @db_current_klasses.push klass
      @db_current_klass = @db_current_klasses.last
      yield
      @db_current_klass = @db_current_klasses.pop
    end

    klass
  end

  def DbCofEducator(options={})
    options ||= { }

    if @db_current_educators.last
      educator = @db_current_educator.last
    else
      attrs = FactoryGirl.attributes_for(:educator)
      attrs[:klass] = DbCofClass(options[:for_class])
      attrs[:user]  = DbCofUser(options[:for_user])
      attrs[:is_instructor] = options[:is_instructor] if options[:is_instructor]
      attrs[:is_assistant]  = options[:is_assistant]  if options[:is_assistant]
      attrs[:is_grader]     = options[:is_grader]     if options[:is_grader]
      educator = FactoryGirl.create(:educator, attrs)
    end

    if block_given?
      @db_current_educators.push klass
      @db_current_educator = @db_current_educators.last
      yield
      @db_current_educator = @db_current_educators.pop
    end

    educator
  end

  def DbCofSection(options={})
    options ||= { }

    if options[:existing]
      section = Section.where{ name == options[:existing] }.first
    elsif @db_current_sections.last
      section = @db_current_sections.last
    else
      attrs = FactoryGirl.attributes_for(:section)
      attrs[:klass] = DbCofClass(options[:for_class])
      attrs[:name]  = options[:name] if options[:name]
      section = FactoryGirl.create(:section, attrs)

      # Klasses automatically contruct a default Section; if the
      # user has specified a custom Section, remove the default.
      bogus_section = attrs[:klass].sections.first
      bogus_section.destroy if bogus_section.name == "DELETE THIS SECTION"
    end

    if block_given?
      @db_current_sections.push section
      @db_current_section = @db_current_sections.last
      yield
      @db_current_section = @db_current_sections.pop
    end

    section    
  end

  def DbCofStudent(options={})
    options ||= { }

    if @db_current_students.last
      student = @db_current_students.last
    else
      attrs = FactoryGirl.attributes_for(:student)
      attrs[:user]    = DbCofUser(options[:for_user])
      attrs[:section] = DbCofSection(options[:for_section])
      student = FactoryGirl.create(:student, attrs)

      if options[:status]
        student.is_auditing = false if options[:status] == :registered
        student.is_auditing = true  if options[:status] == :auditing
        student.drop!               if options[:status] == :dropped
        student.save!
      end
    end

    if block_given?
      @db_current_students.push klass
      @db_current_student = @db_current_students.last
      yield
      @db_current_student = @db_current_students.pop
    end

    student
  end

end

module WorldExtensions

  ##
  ## User-related
  ## 

  def find_users_by_full_name(target_full_name)
    target_first_name, target_last_name = parse_full_name(target_full_name)
    User.where{ (first_name == target_first_name) & (last_name == target_last_name) }
  end

  def find_unique_user_by_full_name(target_full_name)
    users = find_users_by_full_name(target_full_name)
    raise "there are #{users.size} Users with full name '#{target_full_name}'" if users.size != 1
    users[0]
  end

  def create_user_by_full_name(target_full_name)
    target_first_name, target_last_name = parse_full_name(target_full_name)
    FactoryGirl.create(:user, :first_name => target_first_name, :last_name => target_last_name)
    find_unique_user_by_full_name(target_full_name)
  end

  def find_or_create_unique_user_by_full_name(target_full_name)
    find_unique_user_by_full_name(target_full_name)
  rescue Exception
    create_user_by_full_name(target_full_name)
  end

  def parse_full_name(full_name)
    raise "Invalid user full name: '#{full_name}'" unless %r{(?<fname>\w+)\s+(?<lname>\w+)} =~ full_name
    [fname, lname]
  end

  ##
  ## Organization-related
  ## 

  def find_organizations_by_name(target_name)
    Organization.where{ name == target_name }      
  end

  def find_unique_organization_by_name(target_name)
    orgs = find_organizations_by_name(target_name)
    raise "there are #{orgs.size} Organizations with name '#{target_name}'" if orgs.size != 1
    orgs[0]
  end

  def create_organization_by_name(target_name)
    FactoryGirl.create(:organization, :name => target_name)      
    find_unique_organization_by_name(target_name)
  end

  def find_or_create_unique_organization_by_name(target_name)
    find_unique_organization_by_name(target_name)
  rescue
    create_organization_by_name(target_name)
  end

  def find_or_create_unique_organization_course_by_name(org, target_course_name)
    courses = find_courses_by_name(target_course_name)
    raise "there are #{courses.size} Courses with name '#{target_course_name}" if courses.size > 1
    if courses.size == 0
      FactoryGirl.create(:course, :name => target_course_name, :organization => org)
    end

    course = find_unique_course_by_name(target_course_name)
    raise "there is a Course named '#{course.name}' under Organization '#{course.organization.name}'" \
    if course.organization.name != org.name
      course
    end

  ##
  ## Course-related
  ## 

  def find_courses_by_name(target_name)
    Course.where{ name == target_name }
  end

  def find_unique_course_by_name(target_name)
    courses = find_courses_by_name(target_name)
    raise "there are #{courses.size} Courses with name '#{target_name}'" if courses.size != 1
    courses[0]
  end

  def create_course_by_name(target_name)
    FactoryGirl.create(:course, :name => target_name)
  end

  def find_or_create_unique_course_by_name(target_name)
    find_unique_course_by_name(target_name)
  rescue
    create_course_by_name(target_name)
  end

  ##
  ## Class-related
  ## 

  def find_klasses_by_course_name(target_name)
    Klass.joins{ course }.where{ course.name == target_name }
  end

  def find_unique_klass_by_course_name(target_name)
    klasses = find_klasses_by_course_name(target_name)
    raise "there are #{klasses.size} Klasses with name '#{target_name}'" if klasses.size != 1
    klasses[0]
  end

  def create_klass_from_course(course)
    FactoryGirl.create(:klass, :course => course)
  end

  def find_or_create_unique_klass_by_course_name(target_name)
    find_unique_klass_by_course_name(target_name)
  rescue
    course = find_or_create_unique_course_by_name(target_name)
    create_klass_from_course(course)
  end

  ##
  ## Misc Utils
  ## 
  
  # Example usage: save_screen('not_logged_in', URI.parse(current_url).path)
  def save_screen(prefix, path)
    new_path = path.clone
    new_path.gsub!(%r{/}, ":")
    Capybara::Screenshot.screen_shot_and_save_page
    dirname = Rails.root.join('tmp', 'capybara')

    Dir.foreach(dirname) do |file|
      file  = [dirname, file].join('/')

      if /\.html$/ =~ file
        File.unlink(file)
      elsif /screenshot-\d\d\d\d-\d\d-\d\d-\d\d-\d\d-\d\d.png$/ =~ file
        new_basename = [prefix, new_path, '01'].join('_')
        while File.exist?([dirname, '/', new_basename, '.png'].join(''))
          new_basename = new_basename.next
        end
        new_file = [dirname, '/', new_basename, '.png'].join('')
        File.rename(file, new_file)
      end
    end     
  end

  # https://github.com/thoughtbot/capybara-webkit/issues/84
  # https://github.com/jnicklas/capybara/issues/29
  def handle_js_confirm(accept=true)
    page.evaluate_script "window.original_confirm_function = window.confirm"
    page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
    yield
  ensure
    page.evaluate_script "window.confirm = window.original_confirm_function"
  end
  
  def wait_for_browser
    page.find('div#footer')
  end
  
  def verify_test_meta(options)
    msg = nil || options[:fail_message]
    options.each do |key, val|
      next if key == :fail_message
      page.find(:xpath, "//meta[@property='test:#{key}' and @content='#{val}']").should be_true, msg
    end
  end
  
  def mouseover_elem(elem)
    elem.should be_true
    xpath = elem.path
    css = xpath_to_css(xpath)
    cmd = "$(\"#{css}\").trigger('mouseover');"
    cmd = "$(\"#{css}\").trigger('mousemove');"
    cmd = "$(\"#{css}\").trigger('mouseenter');"
    page.execute_script(cmd)
  end
  
  def xpath_to_css(xpath)
    css = xpath.dup
    css.sub!(%r{^/}, '')
    css.gsub!(%r{/}, ' > ')
    css.gsub!(%r{\[(?<val>\d+)\]}, ':nth-child(\k<val>)')
    css.gsub!(%r{@}, '')
  end
end

World(WorldExtensions)
World(Db)


