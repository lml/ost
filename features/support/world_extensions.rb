# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'db_setups_instructor_features'
require 'db_setups_assignment_distribution_features'
World(DbSetup)

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
    page.execute_script(cmd)
    cmd = "$(\"#{css}\").trigger('mousemove');"
    page.execute_script(cmd)
    cmd = "$(\"#{css}\").trigger('mouseenter');"
    page.execute_script(cmd)
  end
  
  def single_click_on(elem)
    elem.click
  end

  def double_click_on(elem)
    elem.should be_true
    xpath = elem.path
    css = xpath_to_css(xpath)
    cmd = "$(\"#{css}\").trigger('dblclick');"
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

