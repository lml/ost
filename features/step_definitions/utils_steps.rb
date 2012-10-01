
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

Given %r{^that (#{CAPTURE_USER_FULL_NAME}) is an admin$} do |target_name|
  user = find_unique_user_by_full_name(target_name)
  if !user.is_administrator?
    user.is_administrator = true
    user.save
  end
  
  user.is_administrator?.should be_true
  user.new_record?.should be_false
end

Then %r{^(#{CAPTURE_USER_FULL_NAME}) is an admin$} do |target_name|
  find_unique_user_by_full_name(target_name).is_administrator?.should be_true
end

Then %r{^(#{CAPTURE_USER_FULL_NAME}) is not an admin$} do |target_name|
  find_unique_user_by_full_name(target_name).is_administrator?.should be_false
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

##
## Course-related
##

Given %r{^that there is a single course named (#{CAPTURE_COURSE_NAME})$} do |target_name|
  course = find_or_create_unique_course_by_name(target_name)
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

  if user != @current_user
    # NOTE: The Devise::TestHelper approach (sign_in user) doesn't work
    #       outside of controller/functional tests.  For details, see:
    #       https://github.com/plataformatec/devise/issues/1114
    visit root_path
    wait_for_browser
    current_path.should eq(root_path), "Could not visit #{root_path}"

    click_link('Sign in')
    wait_for_browser
    current_path.should eq(new_user_session_path)
    
    #save_screen('not_logged_in', URI.parse(current_url).path)
    fill_in "Username", :with => user.username
    fill_in "Password", :with => "password"
    #save_screen('ready_to_click', URI.parse(current_url).path)
    click_button "Sign in"
    wait_for_browser
    current_path.should eq(root_path), "Not redirected to #{root_path} after login (probably invalid username/password combo)"
    page.should have_content("Sign out")
    #save_screen('logged_in', URI.parse(current_url).path)
    @current_user = user
  end

  @current_user.should eq(user)
end

Then %r{^I am logged in as (#{CAPTURE_USER_FULL_NAME})$} do |target_name|
  user = find_unique_user_by_full_name(target_name)
  @current_user.should eq(user)
end

Given %r{^that I am logged out$} do
  if !@current_user.nil?
    visit root_path
    wait_for_browser

    click_on "Sign out"
    wait_for_browser

    page.should have_content("Sign in")
    @current_user = nil
  end
  @current_user.should eq(nil)
end

Then %r{^I am logged out$} do
  @current_user.should eq(nil)
end

When %r{^I log out$} do
  @current_user.should_not eq(nil)
  visit root_path
  wait_for_browser

  click_on "Sign out"
  wait_for_browser
  page.should have_content("Sign in")

  @current_user = nil
end

##
## Page Contents-related
##

Then %r{^I should see a(?:n*?) "(.*?)" link$} do |link_text|
  find_link(link_text).visible?.should be_true
end

Then %r{^I see "(.*?)"$} do |text|
  page.has_content?(text).should be_true
end

Then %r{^I am (?:taken to|on) the "(.*?)" page$} do |page_title|
  page.find('title').has_content?(page_title).should be_true
end

Then %r{^I am taken to the "(.*?)" page for "([^"]*?)"$} do |page_type, major_name|
  page.find(:xpath, "//meta[@property='test:page_type' and @content='#{page_type}']").should be_true
  page.find(:xpath, "//meta[@property='test:major_name' and @content='#{major_name}']").should be_true
end

Then %r{^I am taken to the "(.*?)" page for "([^"]*?)" under "(.*?)"$} do |page_type, minor_name, major_name|
  page.find(:xpath, "//meta[@property='test:page_type' and @content='#{page_type}']").should be_true
  page.find(:xpath, "//meta[@property='test:major_name' and @content='#{major_name}']").should be_true
  page.find(:xpath, "//meta[@property='test:minor_name' and @content='#{minor_name}']").should be_true
end

Then %r{^the "(.*?)" field contains "(.*?)"$} do |field_name, field_content|
  page.has_field?(field_name).should be_true
  page.has_field?(field_name, :with => field_content).should be_true
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
  page.execute_script("$('div.sortable_item_entry:contains(\"#{uberlist_content}\")').trigger('mouseover');")  
  #page.find(:xpath, "//div[@class='sortable_item_entry' and contains(.,'#{uberlist_content}')]").trigger('mouseover')
  find_link("Delete").visible?.should be_true
  handle_js_confirm(accept) do
    click_link "Delete"
  end
  wait_for_browser
end

When %r{^I mouse over the edit icon for "(.*?)"$} do |uberlist_content|
  page.execute_script("$('div.sortable_item_entry:contains(\"#{uberlist_content}\")').trigger('mouseover');")  
  wait_for_browser
end

When %r{^I click (?:on\s)*the edit icon for "(.*?)"$} do |uberlist_content|
  #page.find(:xpath, "//div[@class='sortable_item_entry' and contains(.,'#{uberlist_content}')]").trigger('mouseover')
  page.execute_script("$('div.sortable_item_entry:contains(\"#{uberlist_content}\")').trigger('mouseover');")  
  find_link("Edit").visible?.should be_true
  click_link "Edit"
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

