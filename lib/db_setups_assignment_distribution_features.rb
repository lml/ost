# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'db_dsl'
include DbDsl

module DbSetup

  def assignment_distribution_1CH_1S_100pct_setup

    DbUniverse do

        DbCofUser first_name: "Admin",      last_name: "Jones", username: "admin"
        DbCofUser first_name: "Professor",  last_name: "X",     username: "profx"

        exercise = DbCofExercise url: "http://quadbase.org/questions/q4668v1"

        DbCofOrganization name: "Organization One" do

            DbCofCourse name: "Course One" do
                DbCofInstructor for_user: { existing: "profx" } do
                    DbCofClass start_date: "Sep 1, 2012 5:00am", end_date: "Dec 1, 2012 5:00pm" do
                        cohort = DbCofCohort name: "Cohort One" do
                            DbCofLearningCondition do
                                DbCofPercentScheduler do |scheduler|
                                    scheduler.schedules = [[{percent: 100, tags: "100_percent"}]]
                                    scheduler.save!
                                end
                            end
                        end

                        DbCofSection name: "Section One" do
                            DbCofStudent cohort: cohort, for_user: {first_name: "C1S1CH1R", last_name: "Student"}, status: :registered
                            DbCofStudent cohort: cohort, for_user: {first_name: "C1S1CH1A", last_name: "Student"}, status: :auditing
                            DbCofStudent cohort: cohort, for_user: {first_name: "C1S1CH1D", last_name: "Student"}, status: :dropped
                        end

                        DbCofLearningPlan do
                            concept = DbCofConcept name: "The Concept"

                            ["One", "Two", "Three", "Four"].each_with_index do |number_string, index|
                                topic = DbCofTopic name: "Topic #{number_string}" do
                                    3.times do |x|
                                        DbCofTopicExercise name: "Topic #{number_string} Ex #{x}", exercise: exercise, concept: concept
                                    end
                                end

                                DbCofAssignmentPlan name:       "Homework #{number_string}", 
                                                    starts_at:  "Sep #{1+index}, 2012 6:00am", 
                                                    ends_at:    "Sep #{3+index}, 2012 10:00pm",
                                                    is_ready:   true  do
                                    DbCofAssignmentPlanTopic topic: topic
                                end
                            end
                        end # LearningPlan
                    end
                end
            end # Course

        end # Organization
    end # Universe

  end

end