# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'db_setups_instructor_features'
require 'db_setups_assignment_distribution_features'
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

        task :assignment_distribution_1CH_1S_100pct => ["db:reset", :environment] do 
            assignment_distribution_1CH_1S_100pct_setup
        end

        task :assignment_distribution_1S_1CH_100pct => ["db:reset", :environment] do 
            assignment_distribution_1S_1CH_100pct_setup
        end

        task :assignment_distribution_1CH_2S_100pct => ["db:reset", :environment] do 
            assignment_distribution_1CH_2S_100pct_setup
        end
    end        
end