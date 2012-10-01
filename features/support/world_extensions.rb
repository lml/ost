
CAPTURE_USER_FULL_NAME = Transform /"(.*)"/ do |full_name|
  full_name
end

CAPTURE_ORGANIZATION_NAME = Transform /"(.*)"/ do |org_name|
  org_name
end

CAPTURE_COURSE_NAME = Transform /"(.*)"/ do |course_name|
  course_name
end

CAPTURE_LINK_TEXT = Transform /"(.*)"/ do |link_text|
  link_text
end

module WorldExtensions

  def wait_for_browser
    page.has_content?('')
  end
  
  ##
  ## User-related
  ## 

  def find_users_by_full_name(target_full_name)
    target_first_name, target_last_name = fg_parse_full_name(target_full_name)
    User.where{ (first_name == target_first_name) & (last_name == target_last_name) }
  end

  def find_unique_user_by_full_name(target_full_name)
    users = find_users_by_full_name(target_full_name)
    raise "there are #{users.size} Users with full name '#{target_full_name}'" if users.size != 1
    users[0]
  end

  def create_user_by_full_name(target_full_name)
    target_first_name, target_last_name = fg_parse_full_name(target_full_name)
    FactoryGirl.create(:user, :first_name => target_first_name, :last_name => target_last_name)
    find_unique_user_by_full_name(target_full_name)
  end

  def find_or_create_unique_user_by_full_name(target_full_name)
    find_unique_user_by_full_name(target_full_name)
  rescue Exception
    create_user_by_full_name(target_full_name)
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
  
end

World(WorldExtensions)

