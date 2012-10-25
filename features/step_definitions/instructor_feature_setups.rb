And %r{instructor teach course setup} do
  instructor_teach_course_setup
end

And %r{instructor dashboard setup} do
  instructor_dashboard_setup
end

And %r{instructor enrollment setup} do
  instructor_enrollment_setup
end

And %r{^instructor class learning plan setup$} do
  instructor_class_learning_plan_view_setup
end

And %r{^instructor registration request setup$} do
  instructor_registration_request_setup
end