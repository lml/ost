##
## Db-manipulation related
##
module Db
  def DbCofClass(options={})
    options ||= { }

    if options[:existing]
      klass = Klass.where{ course.name == options[:existing] }.first
    elsif @db_klasses.last
      klass = @db_klasses.last
    else
      attrs = FactoryGirl.attributes_for(:klass)
      attrs[:course]  = DbCofCourse(options[:for_course])
      if options[:for_creator]
        attrs[:creator] = DbCofUser(options[:for_creator])
      elsif @db_instructors.last
        attrs[:creator] = @db_instructors.last.user
      end
      klass = FactoryGirl.create(:klass, attrs)
      klass.sections.first.name = "DELETE THIS SECTION"
      klass.sections.first.save!
    end

    if block_given?
      @db_klasses.push klass
      @db_klass = @db_klasses.last
      yield
      @db_klass = @db_klasses.pop
    end

    klass
  end

  def DbCofConcept(options={})
    options ||= { }

    if options[:existing]
      concept = Concept.where{ name == options[:existing] }.first
    elsif @db_concepts.last
      concept = @db_concepts.last
    else
      attrs = FactoryGirl.attributes_for(:concept)
      attrs[:name]          = options[:name] if options[:name]
      attrs[:learning_plan] = DbCofLearningPlan(options[:for_learning_plan])
      concept = FactoryGirl.create(:concept, attrs)
    end

    if block_given?
      @db_concepts.push concept
      yield
      @db_concepts.pop
    end

    concept
  end

  def DbCofCourse(options={})
    options ||= { }

    if options[:existing]
      course = Course.where{ name == options[:existing] }.first
    elsif @db_courses.last
      course = @db_courses.last
    else
      attrs = FactoryGirl.attributes_for(:course)
      attrs[:name]         = options[:name] if options[:name]
      attrs[:organization] = DbCofOrganization(options[:for_organiztion])
      course = FactoryGirl.create(:course, attrs)
    end

    if block_given?
      @db_courses.push course
      yield
      @db_courses.pop
    end

    course
  end

  def DbCofEducator(options={})
    options ||= { }

    if @db_educators.last
      educator = @db_educator.last
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
      @db_educators.push klass
      @db_educator = @db_educators.last
      yield
      @db_educator = @db_educators.pop
    end

    educator
  end

  def DbCofExercise(options={})
    options ||= { }

    if options[:existing]
      exercise = Exercise.where{ url == options[:existing] }.first
    elsif @db_exercises.last
      exercise = @db_exercises.last
    else
      attrs = FactoryGirl.attributes_for(:exercise)
      attrs[:url]           = options[:url]           if options[:url]
      attrs[:is_dynamic]    = options[:is_dynamic]    if options[:is_dynamic]
      attrs[:content_cache] = options[:content_cache] if options[:content_cache]
      exercise = FactoryGirl.create(:exercise, attrs)
    end

    if block_given?
      @db_exercises.push exercise
      yield
      @db_exercises.pop
    end

    exercise
  end

  def DbCofInstructor(options={})
    options ||= { }

    attrs = FactoryGirl.attributes_for(:course_instructor)
    attrs[:user]   = DbCofUser(options[:for_user])
    attrs[:course] = DbCofCourse(options[:for_course])
    instructor = FactoryGirl.create(:course_instructor, attrs)

    if block_given?
      @db_instructors.push instructor
      yield
      @db_instructors.pop
    end

    instructor
  end

  def DbCofLearningPlan(options={})
    options ||= { }

    if options[:existing]
      learning_plan = LearningPlan.where{ klass.course.name == options[:existing] }.first
    elsif @db_learning_plans.last
      learning_plan = @db_learning_plans.last
    else
      attrs = FactoryGirl.attributes_for(:learning_plan)
      attrs[:klass]       = DbCofClass(options[:for_class])
      attrs[:name]        = options[:name]        if options[:name]
      attrs[:description] = options[:description] if options[:description]
      learning_plan = FactoryGirl.create(:learning_plan, attrs)

      # Klasses create a default Learning Plan, so get rid
      # of that one and replace it with the newly created
      # Learning Plan. 
      bogus_learning_plan = attrs[:klass].learning_plan
      bogus_learning_plan.destroy
      attrs[:klass].learning_plan = learning_plan
      attrs[:klass].save!
    end

    if block_given?
      @db_learning_plans.push learning_plan
      yield
      @db_learning_plans.pop
    end

    learning_plan
  end

  def DbCofOrganization(options={})
    options ||= { }

    if options[:existing]
      organization = Organization.where{ name == options[:existing] }.first
    elsif @db_organizations.last
      organization = @db_organizations.last
    else
      attrs = FactoryGirl.attributes_for(:organization)
      attrs[:name] = options[:name] if options[:name]
      organization = FactoryGirl.create(:organization, attrs)
    end

    if block_given?
      @db_organizations.push organization
      yield
      @db_organizations.pop
    end

    organization
  end

  def DbCofRegistrationRequest(options={})
    options ||= { }

    if @db_registration_requests.last
      request = @db_registration_requests.last
    else
      attrs = FactoryGirl.attributes_for(:registration_request)
      attrs[:user]        = DbCofUser(options[:for_user])
      attrs[:section]     = DbCofSection(options[:for_section])
      attrs[:is_auditing] = options[:is_auditing] if options[:is_auditing]
      request = FactoryGirl.create(:registration_request, attrs)
    end

    if block_given?
      @db_registration_requests.push request
      @db_registration_request = @db_registration_requests.last
      yield
      @db_registration_request = @db_registration_requests.pop
    end

    request
  end

  def DbCofResource(options={})
    options ||= { }

    if options[:existing]
      topic = Resource.where{ name == options[:existing] }.first
    elsif @db_resources.last
      resource = @db_resources.last
    else
      attrs = FactoryGirl.attributes_for(:resource)
      attrs[:topic] = DbCofTopic(options[:for_topic])
      attrs[:name]  = options[:name] if options[:name]
      attrs[:url]   = options[:url]  if options[:url]
      resource = FactoryGirl.create(:resource, attrs)
    end

    if block_given?
      @db_resources.push resource
      yield
      @db_resources.pop
    end

    resource
  end

  def DbCofSection(options={})
    options ||= { }

    if options[:existing]
      section = Section.where{ name == options[:existing] }.first
    elsif @db_sections.last
      section = @db_sections.last
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
      @db_sections.push section
      @db_section = @db_sections.last
      yield
      @db_section = @db_sections.pop
    end

    section    
  end

  def DbCofStudent(options={})
    options ||= { }

    if @db_students.last
      student = @db_students.last
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
      @db_students.push klass
      @db_student = @db_students.last
      yield
      @db_student = @db_students.pop
    end

    student
  end

  def DbCofTopic(options={})
    options ||= { }

    if options[:existing]
      topic = Topic.where{ name == options[:existing] }.first
    elsif @db_topics.last
      topic = @db_topics.last
    else
      attrs = FactoryGirl.attributes_for(:topic)
      attrs[:learning_plan] = DbCofLearningPlan(options[:for_learning_plan])
      attrs[:name]          = options[:name] if options[:name]
      topic = FactoryGirl.create(:topic, attrs)
    end

    if block_given?
      @db_topics.push topic
      yield
      @db_topics.pop
    end

    topic
  end

  def DbCofTopicExercise(options={})
    options ||= { }

    if @db_topic_exercises.last
      topic_exercise = @db_topic_exercises.last
    else
      attrs = FactoryGirl.attributes_for(:topic_exercise)
      attrs[:topic]    = DbCofTopic(options[:for_topic])
      attrs[:exercise] = DbCofExercise(options[:for_exercise])
      attrs[:concept]  = DbCofConcept(options[:for_concept])
      topic_exercise = FactoryGirl.create(:topic_exercise, attrs)
    end

    if block_given?
      @db_topic_exercises.push topic_exercise
      yield
      @db_topic_exercises.pop
    end

    topic_exercise
  end

  def DbCofUser(options={})
    options ||= { }

    if options[:existing]
      user = User.where{ username == options[:existing] }.first
    elsif @db_users.last
      user = @db_users.last
    else
      attrs = FactoryGirl.attributes_for(:user)
      attrs[:first_name]        = options[:first_name]  if options[:first_name]
      attrs[:last_name]         = options[:last_name]   if options[:last_name]
      attrs[:username]          = options[:username]    if options[:username]
      attrs[:is_administrator]  = options[:is_admin]    if options[:is_admin]
      user = FactoryGirl.create(:user, attrs)
    end

    if block_given?
      @db_users.push user
      yield
      @db_users.pop
    end

    user
  end

  def DbUniverse
    @db_concepts              = []
    @db_courses               = []
    @db_educators             = []
    @db_exercises             = []
    @db_instructors           = []
    @db_klasses               = []
    @db_learning_plans        = []
    @db_organizations         = []
    @db_registration_requests = []
    @db_resources             = []
    @db_sections              = []
    @db_students              = []
    @db_topics                = []
    @db_topic_exercises       = []
    @db_users                 = []

    yield if block_given?
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

  def find_innermost_matching_elem(elem, search_entry)

    debug = false

    %r{^(?<class_name>.+?)(\s+containing\s+(?<content>.+))?$} =~ search_entry

    class_name = "test_section" if class_name == "row"
    class_name = "test_section" if class_name == "section"

    if class_name.match(/\s/)
      content = class_name
      class_name      = nil
    end

    if debug
      puts "search entry   = ( #{search_entry} )"
      puts "class_name     = ( #{class_name} )"
      puts "content        = ( #{content} )"
    end

    # NOTE: It turns out the #has_css? modifies the element
    #       when the query fails.  That's why the last matched
    #       xpath is maintained instead of the actual element.
    matched_xpath = nil
    while true
      match_found = false
      if class_name && content
        if elem.has_css?(".test.#{class_name}", :text => content)
          elem = elem.find(".test.#{class_name}", :text => content)
          match_found = true
        end
      elsif class_name
        if elem.has_css?(".test.#{class_name}")
          elem = elem.find(".test.#{class_name}")
          match_found = true
        elsif elem.has_css?(".test", :text => class_name)
          elem = elem.find(".test", :text => class_name)
          match_found = true
        end
      elsif content
        if elem.has_css?(".test", :text => content)
          elem = elem.find(".test", :text => content)
          match_found = true
        end
      end

      matched_xpath = elem.path if match_found

      raise "could not find element for: #{search_entry} (#{class_name}) (#{content})" if matched_xpath.nil?
      break if !match_found

      puts elem_details(elem, "new match element details:", 10) if debug

      if block_given?
        break if !(yield elem)
      end
    end

    matched_xpath  
  end

  def elem_details(elem, notice="element details:", num_indent=10)
    indent = " "*num_indent
    result = indent + notice + "\n"
    result += indent + "   tag: (#{elem.tag_name})\n"
    result += indent + "   id:  (#{elem[:id]})\n"
    result += indent + "   path: (#{elem.path})\n"
    result += indent + "   text: (#{elem.text})\n"
  end
end

World(WorldExtensions)
World(Db)


