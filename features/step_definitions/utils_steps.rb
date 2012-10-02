
##
## User-related
##

Given %r{^that there are no users$} do
  User.find(:all).size.should eq(0)
end

Then %r{^there are no users$} do
  User.find(:all).size.should eq(0)
end

Given %r{^that there is no user named (#{CAPTURE_USER_FULL_NAME})$} do |target_name|
  find_users_by_full_name(target_name).size.should eq(0)
end

Then %r{^there is no user named (#{CAPTURE_USER_FULL_NAME})$} do |target_name|
  find_users_by_full_name(target_name).size.should eq(0)
end

Given %r{^that there is a single user named (#{CAPTURE_USER_FULL_NAME})$} do |target_name|
  find_or_create_unique_user_by_full_name(target_name)
end

Then %r{^there is a single user named (#{CAPTURE_USER_FULL_NAME})$} do |target_name|
  find_unique_user_by_full_name(target_name)
end

Given %r{^that (#{CAPTURE_USER_FULL_NAME}) is (not\s)*an admin$} do |target_name, do_not|
  user = find_unique_user_by_full_name(target_name)

  if do_not
    if user.is_administrator?
      user.is_administrator = false
      user.save
    end
    user.is_administrator?.should be_false
  else
    if !user.is_administrator?
      user.is_administrator = true
      user.save
    end
    user.is_administrator?.should be_true
  end
  user.new_record?.should be_false
end

Then %r{^(#{CAPTURE_USER_FULL_NAME}) is (not\s)*an admin$} do |target_name, do_not|
  if do_not
    find_unique_user_by_full_name(target_name).is_administrator?.should be_false
  else
    find_unique_user_by_full_name(target_name).is_administrator?.should be_true
  end
end

##
## Organization-related
##

Given %r{^that there is a single organization named (#{CAPTURE_ORGANIZATION_NAME})$} do |target_name|
  find_or_create_unique_organization_by_name(target_name)
end

Then %r{^there is a single organization named (#{CAPTURE_ORGANIZATION_NAME})$} do |target_name|
  find_unique_organization_by_name(target_name)
end

Given %r{^that there is no organization named (#{CAPTURE_ORGANIZATION_NAME})$} do |target_name|
  find_organizations_by_name(target_name).size.should eq(0)
end

Then %r{^there is no organization named (#{CAPTURE_ORGANIZATION_NAME})$} do |target_name|
  find_organizations_by_name(target_name).size.should eq(0)
end

Given %r{^that organization (#{CAPTURE_ORGANIZATION_NAME}) has a course named (#{CAPTURE_COURSE_NAME})$} do |organization_name, course_name|
  org = find_or_create_unique_organization_by_name(organization_name)
  find_or_create_unique_organization_course_by_name(org, course_name)
end

##
## Course-related
##

Given %r{^that there is a single course named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  find_or_create_unique_course_by_name(target_name)
end

Then %r{^there is a single course named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  find_unique_course_by_name(target_name)
end

Given %r{^that there is no course named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  find_courses_by_name(target_name).size.should eq(0)
end

Then %r{^there is no course named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  find_courses_by_name(target_name).size.should eq(0)
end

##
## CourseInstructor-related
##

Then %r{^(#{CAPTURE_USER_FULL_NAME}) is an instructor for (#{CAPTURE_COURSE_NAME})$} do |target_user_name, target_course_name|
  user = find_unique_user_by_full_name(target_user_name)
  course = find_unique_course_by_name(target_course_name)
  CourseInstructor.where{ course_id == course.id }.where { user_id == user.id }.size.should eq(1)
end

##
## Klass-related
##

Given %r{^that there is a single class named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  find_or_create_unique_klass_by_course_name(target_name)
end

Then %r{^there is a single class named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  find_unique_klass_by_course_name(target_name)
end

Given %r{^that there is no class named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  find_klasses_by_course_name(target_name).size.should eq(0)
end

Then %r{^there is no class named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  find_klasses_by_course_name(target_name).size.should eq(0)
end

Given %r{^that (#{CAPTURE_USER_FULL_NAME}) is teaching a class named (#{CAPTURE_COURSE_NAME})$} do |target_user_full_name, target_course_name|
  user = find_or_create_unique_user_by_full_name(target_user_full_name)
  klass = find_or_create_unique_klass_by_course_name(target_course_name)
  educator = FactoryGirl.create(:educator, :klass => klass, :user => user, :is_instructor => true)
  klass.is_instructor?(user).should be_true
end

Then %r{^"(.*?)" is teaching a class named "(.*?)"$} do |target_user_full_name, target_course_name|
  user = find_unique_user_by_full_name(target_user_full_name)
  klass = find_unique_klass_by_course_name(target_course_name)
  klass.is_instructor?(user).should be_true
end

##
## Login/Logout-related
##

Given %r{^that I am logged in as (#{CAPTURE_USER_FULL_NAME})$} do |target_name|
  user = find_or_create_unique_user_by_full_name(target_name)
  
  if user.id != @current_user_id
    # NOTE: The Devise::TestHelper approach (sign_in user) doesn't work
    #       outside of controller/functional tests.  For details, see:
    #       https://github.com/plataformatec/devise/issues/1114
    visit root_path
    wait_for_browser
    verify_test_meta :page_type => "index", :major_name => "Home"

    click_link('Sign in')
    wait_for_browser
    verify_test_meta(:page_type => "new", :major_name => "Devise::Session")
    
    fill_in "Username", :with => user.username
    fill_in "Password", :with => "password"
    click_button "Sign in"
    wait_for_browser
    verify_test_meta(:page_type => "index", :major_name => "Home") 
    verify_test_meta(:current_user_id => user.id)
    @current_user_id = user.id

    page.should have_content("Sign out")
  end
  verify_test_meta :current_user_id => user.id
  @current_user_id.should eq(user.id)
end

Then %r{^I am logged in as (#{CAPTURE_USER_FULL_NAME})$} do |target_name|
  user = find_unique_user_by_full_name(target_name)
  verify_test_meta :current_user_id => user.id
end

Given %r{^that I am logged out$} do
  if !@current_user_id.nil?
    visit root_path
    wait_for_browser
  
    click_on "Sign out"
    wait_for_browser
  
    page.should have_content("Sign in")
    @current_user_id = nil
  end
  @current_user_id.should eq(nil)
end

Then %r{^I am logged out$} do
  @current_user_id.should eq(nil)
end

Then %r{^I am not logged out$} do
  @current_user_id.should_not eq(nil)
  verify_test_meta :current_user_id => @current_user_id
end

When %r{^I log out$} do
  @current_user_id.should_not eq(nil)
  visit root_path
  wait_for_browser

  click_on "Sign out"
  wait_for_browser
  page.should have_content("Sign in")

  @current_user_id = nil
end

##
## Page Contents-related
##

Then %r{^I should see a(?:n*?) "(.*?)" link$} do |link_text|
  find_link(link_text).visible?.should be_true
end

Then %r{^I am (?:taken to|on) the "(.*?)" page$} do |page_type|
  verify_test_meta :page_type => page_type
end

Then %r{^I am taken to the "(.*?)" page for "([^"]*?)"$} do |page_type, major_name|
  verify_test_meta :page_type => page_type, :major_name => major_name
end

Then %r{^I am (?:taken to|on) the "(.*?)" page for "([^"]*?)" under "(.*?)"$} do |page_type, minor_name, major_name|
  verify_test_meta :page_type => page_type, :major_name => major_name, :minor_name => minor_name
end

Then %r{^the "(.*?)" field contains "(.*?)"$} do |field_name, field_content|
  page.has_field?(field_name).should be_true
  page.has_field?(field_name, :with => field_content).should be_true
end

Then %r{^I (do not\s)*see the "(.*?)" dialog$} do |do_not, dialog_title|
  title_span_xpath = "//span[@class='ui-dialog-title' and text()='#{dialog_title}']"
  title_span = page.find(:xpath, title_span_xpath) if page.has_xpath?(title_span_xpath)

  if do_not
    if title_span
      title_span.visible?.should be_false
    end
  else
    title_span.should be_true
    title_span.visible?.should be_true
  end
end

Then %r{^I (do not\s)*see "([^"]*?)"$} do |do_not,content|
  if do_not
    page.has_no_content?(content).should be_true
  else
    page.has_content?(content).should be_true
  end
end

Then %r{^I (do not\s)*see (?:a|an|the) "([^"]*?)" link$} do |do_not,link_name|
  if do_not
    page.has_no_link?(link_name).should be_true
  else
    page.has_link?(link_name).should be_true
  end
end

##
## User Action-related
##

When %r{^I click (?:on\s)*?the (#{CAPTURE_LINK_TEXT}) tab$} do |link_text|
  elem = find(:xpath, "//span[text()='#{link_text.upcase}']")
  elem.visible?.should be true
  elem.click
  wait_for_browser
end

When %r{^I click (?:on\s)*?the (#{CAPTURE_LINK_TEXT}) link$} do |link_text|
  find_link(link_text).visible?.should be_true
  click_link link_text
  wait_for_browser
end

When %r{^I click (?:on\s)*?the (#{CAPTURE_LINK_TEXT}) link and "(.*?)"$} do |link_text, confirm_or_decline|
  find_link(link_text).visible?.should be_true
  confirm = /confirm|accept/i =~ confirm_or_decline
  handle_js_confirm(confirm) { click_link link_text }
  wait_for_browser
end

When %r{^I visit the main page$} do
  visit root_path
  wait_for_browser
end

When %r{^I enter "(.*?)" in the "(.*?)" field$} do |text, field_name|
  fill_in field_name, :with => text
end

When %r{^I select "(.*?)" (?:for|from) "(.*?)"$} do |option, selector|
  select option, :from => selector
end

When %r{^I (?:click(?:\son)*|press) the "(.*?)" button$} do |button_name|
  click_on button_name
  wait_for_browser
end

When %r{^I click (?:on\s)*the delete icon for "(.*?)" and "(.*?)"$} do |uberlist_content, confirm_or_decline|
  accept = /confirm|accept/i =~ confirm_or_decline
  uberlist_mouseover(uberlist_content)
  elem = uberlist_find_delete_link(uberlist_content)
  elem.visible?.should be_true
  handle_js_confirm(accept) do
    elem.click
  end
  wait_for_browser
end

When %r{^I mouse over the edit icon for "(.*?)"$} do |uberlist_content|
  uberlist_mouseover(uberlist_content)
  wait_for_browser
end

When %r{^I click (?:on\s)*the edit icon for "(.*?)"$} do |uberlist_content|
  uberlist_mouseover(uberlist_content)
  elem = uberlist_find_edit_link(uberlist_content)
  elem.visible?.should be_true
  elem.click
  wait_for_browser
end

##
## Misc Util-related
##

And %r{^screencapture "(.*?)"$} do |prefix|
  save_screen(prefix, URI.parse(current_url).path)
end

And %r{^dump paths$} do
  puts current_path
  puts current_url
  puts URI.parse(current_url).path
end

