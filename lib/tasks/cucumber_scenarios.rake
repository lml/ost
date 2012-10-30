require 'db_setups_instructor_features'
include DbSetup

namespace :db do
    namespace :cucumber do
        task :instructor_class_learning_plan_view => ["db:reset", :environment] do 
            instructor_class_learning_plan_view_setup
        end
        task :instructor_dashboard => ["db:reset", :environment] do 
            instructor_dashboard_setup
        end

        task :instructor_enrollment => ["db:reset", :environment] do 
            instructor_enrollment_setup
        end

        task :instructor_registration_request => ["db:reset", :environment] do 
            instructor_registration_request_setup
        end

        task :instructor_teach_course => ["db:reset", :environment] do 
            instructor_teach_course_setup
        end
    end        
end