# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'spec_helper'
require 'db_dsl'
include DbDsl

describe PercentScheduler do

    context "creation-related features" do
        it "can be created with valid attributes" do
            DbUniverse do
                DbCofPercentScheduler().should be_true
            end
        end
        it "cannot be created with invalid schedule row (percentage < 0)" do
            expect {
                attrs = FactoryGirl.attributes_for(:percent_scheduler)
                attrs[:schedules] = [[ {:percent => -5} ]]
                course = PercentScheduler.create(attrs)
                course.save!
            }.to raise_error
        end
        it "cannot be created with invalid schedule row (percentage > 100)" do
            expect {
                attrs = FactoryGirl.attributes_for(:percent_scheduler)
                attrs[:schedules] = [[ {:percent => 100.1} ]]
                course = PercentScheduler.create(attrs)
                course.save!
            }.to raise_error
        end
    end # context

    describe "#standard_practice_scheduler" do
        it "returns a new PercentScheduler with one schedule (100%, 'standard practice')" do
            scheduler = PercentScheduler.standard_practice_scheduler
            scheduler.schedules.should eq [[ {:percent => 100, :tags => "standard practice"} ]]
        end
    end

    context "schedule manipulation methods" do
        describe "#add_schedule" do
            context "scheduler has no schedules" do
                it "adds a new schedule [{0%, ''}] and returns it" do
                    scheduler = FactoryGirl.create(:percent_scheduler)
                    scheduler.schedules.size.should eq 0
                    schedule = scheduler.add_schedule
                    scheduler.schedules.size.should eq 1
                    scheduler.schedules.last.should equal(schedule)
                end
            end
            context "scheduler has schedules" do
                it "adds a new schedule [{0%, ''}] and returns it" do
                    scheduler = FactoryGirl.create(:percent_scheduler, schedules: [[ {:percent => 70, :tags => "tag1"} ],
                                                                                   [ {:percent => 30, :tags => "tag2"} ]])
                    scheduler.schedules.size.should eq 2
                    schedule = scheduler.add_schedule
                    scheduler.schedules.size.should eq 3
                    scheduler.schedules.last.should equal(schedule)
                end
            end
        end
        describe "#add_schedule_row(schedule_index)" do
            context "schedule has no schedules" do
                it "throws when schedule_index == 0" do
                    expect {
                        scheduler = FactoryGirl.create(:percent_scheduler)
                        scheduler.schedules.size.should eq 0
                        schedule = scheduler.add_schedule_row(0)
                    }.to raise_error
                end
                it "throws when schedule_index > 0" do
                    expect {
                        scheduler = FactoryGirl.create(:percent_scheduler)
                        scheduler.schedules.size.should eq 0
                        schedule = scheduler.add_schedule_row(3)
                    }.to raise_error
                end
            end
            context "schedule has schedules" do
                it "throws when schedule_index >= schedules.size (schedules.size == 1)" do
                    expect {
                        scheduler = FactoryGirl.create(:percent_scheduler, schedules: [[ {:percent => 70, :tags => "tag1"} ]])
                        scheduler.schedules.size.should eq 1
                        schedule = scheduler.add_schedule_row(1)
                    }.to raise_error
                end
                it "throws when schedule_index >= schedules.size (schedules.size > 1)" do
                    expect {
                        scheduler = FactoryGirl.create(:percent_scheduler, schedules: [[ {:percent => 70, :tags => "tag1"} ],
                                                                                       [ {:percent => 30, :tags => "tag2"} ]])
                        scheduler.schedules.size.should eq 1
                        schedule = scheduler.add_schedule_row(1)
                    }.to raise_error
                end
                it "throws when schedule_index < 0" do
                    expect {
                        scheduler = FactoryGirl.create(:percent_scheduler, schedules: [[ {:percent => 70, :tags => "tag1"} ],
                                                                                       [ {:percent => 30, :tags => "tag2"} ]])
                        scheduler.schedules.size.should eq 1
                        schedule = scheduler.add_schedule_row(-1)
                    }.to raise_error
                end
                it "adds schedule row {0%, ''} to schedules[schedule_index] and returns the updated schedule row and it's 1-indexed row number" do
                    [0, 1, 2].each do |schedule_index|
                        scheduler = FactoryGirl.create(:percent_scheduler, schedules: [[ {:percent => 70, :tags => "tag1"} ],
                                                                                       [ {:percent => 20, :tags => "tag2"} ],
                                                                                       [ {:percent => 10, :tags => "tag3"} ]])
                        scheduler.schedules.size.should eq 3
                        scheduler.schedules[schedule_index].size.should eq 1

                        schedule_row, row_number = scheduler.add_schedule_row(schedule_index)

                        scheduler.schedules.size.should eq 3
                        scheduler.schedules[schedule_index].size.should eq 2
                        scheduler.schedules[schedule_index].last.should equal(schedule_row)
                        scheduler.schedules[schedule_index].last.should eq({:percent => 0, :tags => ""})
                        row_number.should eq 2
                    end
                end
            end
        end
        describe "#pop_schedule_row(schedule_index)" do
            it "removes and returns the last schedule row in schedules[schedule_index]" do
                [0, 1, 2].each do |schedule_index|
                    scheduler = FactoryGirl.create(:percent_scheduler, schedules: [[ {:percent => 70, :tags => "tag1"}, {:percent => 0, :tags => "tagLast1"} ],
                                                                                   [ {:percent => 20, :tags => "tag2"}, {:percent => 1, :tags => "tagLast2"} ],
                                                                                   [ {:percent => 10, :tags => "tag3"}, {:percent => 2, :tags => "tagLast3"} ]])
                    scheduler.schedules.size.should eq 3
                    scheduler.schedules[schedule_index].size.should eq 2

                    schedule_row = scheduler.pop_schedule_row(schedule_index)

                    scheduler.schedules.size.should eq 3
                    scheduler.schedules[schedule_index].size.should eq 1

                    schedule_row[:percent].should eq(schedule_index)
                end
            end
        end
    end # context

    context "assignment distribution" do
        describe "#build_assignment(assignment_plan, cohort)" do
            context "AssignmentPlan is a test" do
                it "raises IllegalOperation" do
                    assignment_plan = nil
                    cohort          = nil
                    scheduler       = nil

                    DbUniverse do
                        DbCofClass start_date: "Sep 1, 2012 5:00am", end_date: "Dec 1, 2012 5:00pm" do
                            assignment_plan = DbCofAssignmentPlan is_test: true
                            cohort          = DbCofCohort() do
                                DbCofLearningCondition do
                                    scheduler = DbCofPercentScheduler()
                                end 
                            end
                        end
                    end

                    expect {
                        scheduler.build_assignment(assignment_plan, cohort)
                    }.to raise_error(IllegalOperation)
                end
            end
            context "there are no schedules" do
                it "raises IllegalArgument" do
                    assignment_plan = nil
                    cohort          = nil
                    scheduler       = nil

                    DbUniverse do
                        DbCofClass start_date: "Sep 1, 2012 5:00am", end_date: "Dec 1, 2012 5:00pm" do
                            assignment_plan = DbCofAssignmentPlan is_test: false
                            cohort          = DbCofCohort() do
                                DbCofLearningCondition do
                                    scheduler = DbCofPercentScheduler()
                                end 
                            end
                        end
                    end

                    expect {
                        scheduler.build_assignment(assignment_plan, cohort)
                    }.to raise_error(IllegalArgument)
                end
            end
            context "there are no TopicExercises" do
                it "returns a well-formed empty Assignment" do
                    assignment_plan = nil
                    cohort          = nil
                    scheduler       = nil

                    DbUniverse do
                        DbCofClass start_date: "Sep 1, 2012 5:00am", end_date: "Dec 1, 2012 5:00pm" do
                            assignment_plan = DbCofAssignmentPlan is_test: false
                            cohort          = DbCofCohort() do
                                DbCofLearningCondition do
                                    scheduler = DbCofPercentScheduler() do |scheduler|
                                        scheduler.schedules = [[ {:percent => 100, :tags => "tag1"} ]]
                                        scheduler.save!
                                    end
                                end 
                            end
                        end
                    end

                    assignment = scheduler.build_assignment(assignment_plan, cohort)

                    assignment.assignment_plan.should equal(assignment_plan)
                    assignment.cohort.should equal(cohort)
                    assignment.assignment_exercises.size.should eq 0                
                end
            end
            it "chooses the appropriate schedule" do
                assignment_plan1 = nil
                assignment_plan2 = nil
                assignment_plan3 = nil
                cohort           = nil
                scheduler        = nil

                DbUniverse do

                    exercise = DbCofExercise url: "http://quadbase.org/questions/q4668v1"

                    DbCofClass start_date: "Sep 1, 2012 5:00am", end_date: "Dec 1, 2012 5:00pm" do
                        DbCofLearningPlan do
                            topic1 = DbCofTopic name: "Topic One" do
                                DbCofTopicExercise name: "Topic One Exercise One",   exercise: exercise
                            end
                            topic2 = DbCofTopic name: "Topic Two" do
                                DbCofTopicExercise name: "Topic Two Exercise One",   exercise: exercise
                            end
                            topic3 = DbCofTopic name: "Topic Three" do
                                DbCofTopicExercise name: "Topic Three Exercise One", exercise: exercise
                            end

                            assignment_plan1 = DbCofAssignmentPlan   starts_at:  "Sep 1, 2012 6:00am", 
                                                                     ends_at:    "Sep 3, 2012 10:00pm",
                                                                     is_test:    false do
                                DbCofAssignmentPlanTopic topic: topic1
                            end
                            assignment_plan2 = DbCofAssignmentPlan   starts_at:  "Sep 2, 2012 6:00am", 
                                                                     ends_at:    "Sep 4, 2012 10:00pm",
                                                                     is_test:    false do
                                DbCofAssignmentPlanTopic topic: topic2
                            end
                            assignment_plan3 = DbCofAssignmentPlan   starts_at:  "Sep 3, 2012 6:00am", 
                                                                     ends_at:    "Sep 5, 2012 10:00pm",
                                                                     is_test:    false do
                                DbCofAssignmentPlanTopic topic: topic3
                            end
                            cohort          = DbCofCohort() do
                                DbCofLearningCondition do
                                    scheduler = DbCofPercentScheduler() do |scheduler|
                                        scheduler.schedules = [[ {:percent => 100, :tags => "tag1"} ],
                                                               [ {:percent => 100, :tags => "tag2"} ],
                                                               [ {:percent => 100, :tags => "tag3"} ]]
                                        scheduler.save!
                                    end
                                end 
                            end
                        end
                    end
                end

                assignment1 = scheduler.build_assignment(assignment_plan1, cohort)
                assignment2 = scheduler.build_assignment(assignment_plan2, cohort)
                assignment3 = scheduler.build_assignment(assignment_plan3, cohort)

                assignment1.assignment_exercises.each {|ae| ae.tag_list.find{|tag| tag == "tag1"}.should be_true}
                assignment2.assignment_exercises.each {|ae| ae.tag_list.find{|tag| tag == "tag2"}.should be_true}
                assignment3.assignment_exercises.each {|ae| ae.tag_list.find{|tag| tag == "tag3"}.should be_true}
            end
            context "AssignmentPlan covers multiple Topics" do
                it "pulls TopicExercises from each Topic until scheduled percentage is reached (but not exceeded)" do
                    assignment_plan = nil
                    cohort          = nil
                    scheduler       = nil

                    DbUniverse do

                        exercise = DbCofExercise url: "http://quadbase.org/questions/q4668v1"

                        DbCofClass start_date: "Sep 1, 2012 5:00am", end_date: "Dec 1, 2012 5:00pm" do
                            DbCofLearningPlan do
                                topic1 = DbCofTopic name: "Topic One" do
                                    DbCofTopicExercise name: "Topic One Exercise One",   exercise: exercise
                                    DbCofTopicExercise name: "Topic One Exercise Two",   exercise: exercise
                                    DbCofTopicExercise name: "Topic One Exercise Three", exercise: exercise
                                end
                                topic2 = DbCofTopic name: "Topic Two" do
                                    DbCofTopicExercise name: "Topic Two Exercise One",   exercise: exercise
                                    DbCofTopicExercise name: "Topic Two Exercise Two",   exercise: exercise
                                    DbCofTopicExercise name: "Topic Two Exercise Three", exercise: exercise
                                    DbCofTopicExercise name: "Topic Two Exercise Four",  exercise: exercise
                                end
                                topic3 = DbCofTopic name: "Topic Three" do
                                    DbCofTopicExercise name: "Topic Three Exercise One", exercise: exercise
                                end

                                assignment_plan = DbCofAssignmentPlan   starts_at:  "Sep 1, 2012 6:00am", 
                                                                        ends_at:    "Sep 3, 2012 10:00pm",
                                                                        is_test:    false do
                                    DbCofAssignmentPlanTopic topic: topic1
                                    DbCofAssignmentPlanTopic topic: topic2
                                    DbCofAssignmentPlanTopic topic: topic3
                                end
                                cohort          = DbCofCohort() do
                                    DbCofLearningCondition do
                                        scheduler = DbCofPercentScheduler() do |scheduler|
                                            scheduler.schedules = [[ {:percent => 50, :tags => "tag1"} ]]
                                            scheduler.save!
                                        end
                                    end 
                                end
                            end
                        end
                    end

                    assignment = scheduler.build_assignment(assignment_plan, cohort)

                    assignment.assignment_plan.should equal(assignment_plan)
                    assignment.cohort.should equal(cohort)
                    assignment.assignment_exercises.size.should eq 3

                    assignment.assignment_exercises.any?{|ae| ae.topic_exercise.name == "Topic One Exercise One"  }.should be_true
                    assignment.assignment_exercises.any?{|ae| ae.topic_exercise.name == "Topic One Exercise Two"  }.should be_false
                    assignment.assignment_exercises.any?{|ae| ae.topic_exercise.name == "Topic One Exercise Three"}.should be_false

                    assignment.assignment_exercises.any?{|ae| ae.topic_exercise.name == "Topic Two Exercise One"  }.should be_true
                    assignment.assignment_exercises.any?{|ae| ae.topic_exercise.name == "Topic Two Exercise Two"  }.should be_true
                    assignment.assignment_exercises.any?{|ae| ae.topic_exercise.name == "Topic Two Exercise Three"}.should be_false
                    assignment.assignment_exercises.any?{|ae| ae.topic_exercise.name == "Topic Two Exercise Four" }.should be_false

                    assignment.assignment_exercises.any?{|ae| ae.topic_exercise.name == "Topic Three Exercise One"}.should be_false
                end
            end
        end

    end # context
end