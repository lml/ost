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
                    scheduler.schedules.last.should == schedule
                end
            end
            context "scheduler has schedules" do
                it "adds a new schedule [{0%, ''}] and returns it" do
                    scheduler = FactoryGirl.create(:percent_scheduler, schedules: [[ {:percent => 70, :tags => "tag1"} ],
                                                                                   [ {:percent => 30, :tags => "tag2"} ]])
                    scheduler.schedules.size.should eq 2
                    schedule = scheduler.add_schedule
                    scheduler.schedules.size.should eq 3
                    scheduler.schedules.last.should == schedule
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
                        scheduler.schedules[schedule_index].last.should == schedule_row
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
        describe "#build_assignment" do
            
        end
    end # context
end