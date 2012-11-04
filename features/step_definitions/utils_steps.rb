# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

##
## Before/after hooks
##

Before do
  Timecop.return
  # DatabaseCleaner.start
end

After do
  Timecop.return
  # DatabaseCleaner.clean
end

##
## User-related
##

Given %r{^that there are no users$} do
  User.find(:all).size.should eq(0)
end

Then %r{^there are no users$} do
  User.find(:all).size.should eq(0)
end

Given %r{^that there is no user named "([^"]*?)"$} do |target_name|
  find_users_by_full_name(target_name).size.should eq(0)
end

Then %r{^there is no user named "([^"]*?)"$} do |target_name|
  find_users_by_full_name(target_name).size.should eq(0)
end

Given %r{^that there is a single user named "([^"]*?)"$} do |target_name|
  find_or_create_unique_user_by_full_name(target_name)
end

Then %r{^there is a single user named "([^"]*?)"$} do |target_name|
  find_unique_user_by_full_name(target_name)
end

Given %r{^that "([^"]*?)" is (not\s)*an admin$} do |target_name, do_not|
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

Then %r{^"([^"]*?)" is (not\s)*an admin$} do |target_name, do_not|
  if do_not
    find_unique_user_by_full_name(target_name).is_administrator?.should be_false
  else
    find_unique_user_by_full_name(target_name).is_administrator?.should be_true
  end
end

##
## Organization-related
##

Given %r{^that there is a single organization named "([^"]*?)"$} do |target_name|
  find_or_create_unique_organization_by_name(target_name)
end

Then %r{^there is a single organization named "([^"]*?)"$} do |target_name|
  find_unique_organization_by_name(target_name)
end

Given %r{^that there is no organization named "([^"]*?)"$} do |target_name|
  find_organizations_by_name(target_name).size.should eq(0)
end

Then %r{^there is no organization named "([^"]*?)"$} do |target_name|
  find_organizations_by_name(target_name).size.should eq(0)
end

Given %r{^that organization "([^"]*?)" has a course named "([^"]*?)"$} do |organization_name, course_name|
  org = find_or_create_unique_organization_by_name(organization_name)
  find_or_create_unique_organization_course_by_name(org, course_name)
end

##
## Course-related
##

Given %r{^that there is a single course named "([^"]*?)"$} do |target_name|
  find_or_create_unique_course_by_name(target_name)
end

Then %r{^there is a single course named "([^"]*?)"$} do |target_name|
  find_unique_course_by_name(target_name)
end

Given %r{^that there is no course named "([^"]*?)"$} do |target_name|
  find_courses_by_name(target_name).size.should eq(0)
end

Then %r{^there is no course named "([^"]*?)"$} do |target_name|
  find_courses_by_name(target_name).size.should eq(0)
end

##
## CourseInstructor-related
##

Then %r{^"([^"]*?)" is an instructor for "([^"]*?)"$} do |target_user_name, target_course_name|
  user = find_unique_user_by_full_name(target_user_name)
  course = find_unique_course_by_name(target_course_name)
  CourseInstructor.where{ course_id == course.id }.where { user_id == user.id }.size.should eq(1)
end

##
## Klass-related
##

Given %r{^that there is a single class named "([^"]*?)"$} do |target_name|
  find_or_create_unique_klass_by_course_name(target_name)
end

Then %r{^there is a single class named "([^"]*?)"$} do |target_name|
  find_unique_klass_by_course_name(target_name)
end

Given %r{^that there is no class named "([^"]*?)"$} do |target_name|
  find_klasses_by_course_name(target_name).size.should eq(0)
end

Then %r{^there is no class named "([^"]*?)"$} do |target_name|
  find_klasses_by_course_name(target_name).size.should eq(0)
end

Then %r{^"(.*?)" is teaching a class named "(.*?)"$} do |target_user_full_name, target_course_name|
  user = find_unique_user_by_full_name(target_user_full_name)
  klass = find_unique_klass_by_course_name(target_course_name)
  klass.is_instructor?(user).should be_true
end

##
## Login/Logout-related
##

Given %r{^that I am logged in as "([^"]*?)"$} do |target_name|
  user = find_or_create_unique_user_by_full_name(target_name)
  
  if user.id != @current_user_id
    # NOTE: The Devise::TestHelper approach (sign_in user) doesn't work
    #       outside of controller/functional tests.  For details, see:
    #       https://github.com/plataformatec/devise/issues/1114
    visit root_path
    wait_for_browser
    verify_test_meta :page_type => "index", :major_name => "Home"

    find('.test.clickable.sign_in').click
    wait_for_browser
    verify_test_meta(:page_type => "new", :major_name => "Devise::Session")
    
    find('.test.input.user_username').fill_in "user_username", :with => user.username
    find('.test.input.user_password').fill_in "user_password", :with => "password"
    find('.test.clickable.submit').click

    wait_for_browser
    verify_test_meta(:page_type => "index", :major_name => "Home") 
    verify_test_meta(:current_user_id => user.id)
    find('.test.clickable.sign_out').should be_true

    @current_user_id = user.id
  end
  verify_test_meta :current_user_id => user.id
  @current_user_id.should eq(user.id)
end

Then %r{^I am logged in as "([^"]*?)"$} do |target_name|
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

Then %r{^I see a flash containing "(.*?)"$} do |content|
  page.find('div[id="attention"]').has_content?(content).should be_true
end

##
## User Action-related
##

Then %r{^(?:in|under) (.*?) I (can\s|do\s|do not\s|cannot\s|can not\s|don't\s|)?see "([^"]*?)"$} do |search_text, can_cannot, target_content|
  orig_search_text = search_text.dup
  elem             = page

  want_to_see = %r{do not\s|cannot\s|can not\s|don't\s} !~ can_cannot

  while %r{"(?<search_entry>[^"]+?)"} =~ search_text
    search_text = $~.post_match

    matched_xpath = find_innermost_matching_elem(elem, search_entry)

    elem = page.find(:xpath, matched_xpath)
  end

  # puts elem_details(elem, "final element details:", 10)

  if want_to_see
    elem.has_content?(target_content).should be_true
  else
    elem.has_no_content?(target_content).should be_true
  end

end

When %r{^I (double\s|double-)?click on (.+)$} do |double_click, search_text|

  orig_search_text = search_text.dup
  elem             = page
  accept           = true

  while %r{"(?<search_entry>[^"]+?)"} =~ search_text
    search_text = $~.post_match

    if %r{^and (confirm|accept)$} =~ search_entry
      accept = true
      next
    elsif %r{^and (decline|reject)$} =~ search_entry
      accept = false
      next
    end

    matched_xpath = find_innermost_matching_elem(elem, search_entry) do |e|
      mouseover_elem(e)
      true
    end

    elem = page.find(:xpath, matched_xpath)
  end

  elem = elem.find(".test.clickable") if !elem[:class].include?('clickable')

  # puts elem_details(elem, "final element details:", 10)

  elem.visible?.should be true

  handle_js_confirm(accept) do
    double_click.nil? ? single_click_on(elem) : double_click_on(elem)
  end
  wait_for_browser
end

When %r{^I visit the main page$} do
  visit root_path
  wait_for_browser
end

When %r{^I refresh the page$} do
  visit current_path
  wait_for_browser
end

When %r{^I enter "(.*?)" in the "(.*?)" field$} do |text, field_name|
  fill_in field_name, :with => text
end

When %r{^I select "(.*?)" (?:for|from) "(.*?)"$} do |option, selector|
  select option, :from => selector
end

##
## Misc Util-related
##

And %r{^I time travel to "([^"]+?)" "([^"]+?)"$} do |time_str, zone_str|
  Timecop.return
  new_time_utc = TimeUtils.timestr_and_zonestr_to_utc_time(time_str, zone_str)
  Timecop.travel(new_time_utc)
end

include Ost::Cron

And %r{^cron jobs (?:are|have been|were) run} do
  Ost::execute_cron_jobs
end

And %r{^screencapture "(.*?)"$} do |prefix|
  save_screen(prefix, URI.parse(current_url).path)
end

And %r{^debugger$} do
  debugger
end

And %r{^dump paths$} do
  puts current_path
  puts current_url
  puts URI.parse(current_url).path
end

