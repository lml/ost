# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'spec_helper'
require 'db_dsl'
include DbDsl

describe Course do

    context "creation-related features" do
        it "can be created with valid attributes" do
            DbUniverse do
                DbCofCourse().should be_true
            end
        end
        it "cannot be created without a name" do
            expect {
                attrs = FactoryGirl.attributes_for(:course)
                attrs[:name] = nil
                course = Course.create(attrs)
                course.save!
            }.to raise_error
        end
        it "can be created with an Organization-specific name" do
            expect {
                DbUniverse do
                    DbCofOrganization do
                        DbCofCourse name: "Course Name 1"
                        DbCofCourse name: "Course Name 2"
                    end
                    DbCofOrganization do
                        DbCofCourse name: "Course Name 1"
                        DbCofCourse name: "Course Name 2"
                    end
                end
            }.to_not raise_error
        end
        it "cannot be created without an Organization-specific name" do
            expect {
                DbUniverse do
                    DbCofOrganization do
                        DbCofCourse name: "Course Name"
                        DbCofCourse name: "Course Name"
                    end
                end
            }.to raise_error
        end
        it "cannot be created without an associated Organization" do
            expect {
                attrs = FactoryGirl.attributes_for(:course)
                attrs[:organization] = nil
                course = Course.create(attrs)
                course.save!
            }.to raise_error
        end
    end

    context "destruction-related features" do
        it "destroys associated CourseInstructors" do
            @course = nil
            DbUniverse do
                @course = DbCofCourse do
                    DbCofInstructor()
                    DbCofInstructor()
                end
            end
            CourseInstructor.all.size.should be > 0
            @course.destroy
            CourseInstructor.all.size.should eq 0
        end
        it "destroys associated Classes" do
            @course = nil
            DbUniverse do
                @course = DbCofCourse do
                    DbCofClass()
                    DbCofClass()
                end
            end
            se = WebsiteConfiguration.get_value(:sudo_enabled)
            wc = WebsiteConfiguration.find_by_name('sudo_enabled')
            wc.value = true
            wc.save!
            expect { @course.destroy }.to change{Klass.all.size}.by(-2)
            wc.value = se
            wc.save!
        end
    end # context

    context "permission-related methods" do

        before(:each) do
            @admin      = nil
            @user1      = nil
            @user2      = nil
            @instructor = nil
            @course     = nil

            DbUniverse do
                @admin       = DbCofUser is_admin: true
                @user1       = DbCofUser is_admin: false
                @user2       = DbCofUser is_admin: false
                @instructor  = DbCofUser is_admin: false
                @course = DbCofCourse do
                    DbCofInstructor user: @instructor
                end
                DbCofCourse do
                    DbCofInstructor user: @user2
                end
            end
        end

        describe "#is_instructor?(user)" do
            it "returns true if user is an instructor for the course" do
                @course.is_instructor?(@instructor).should be_true
            end
            it "returns false if user is not an instructor for course" do
                @course.is_instructor?(@admin).should be_false
                @course.is_instructor?(@user1).should be_false
                @course.is_instructor?(@user2).should be_false
            end
        end

        describe "#can_be_read_by?(user)" do
            it "returns true for any user" do
                @course.can_be_read_by?(@admin).should be_true
                @course.can_be_read_by?(@user1).should be_true
                @course.can_be_read_by?(@user2).should be_true
                @course.can_be_read_by?(@instructor).should be_true
            end
        end

        describe "#can_be_created_by?(user)" do
            it "returns true if user is an admin" do
                @course.can_be_created_by?(@admin).should be_true
            end
            it "returns false if user if not an admin" do
                @course.can_be_created_by?(@user1).should be_false
                @course.can_be_created_by?(@user2).should be_false
                @course.can_be_created_by?(@instructor).should be_false
            end
        end

        describe "#can_be_updated_by?(user)" do
            it "returns true if user is an admin" do
                @course.can_be_updated_by?(@admin).should be_true
            end
            it "returns false if user if not an admin" do
                @course.can_be_updated_by?(@user1).should be_false
                @course.can_be_updated_by?(@user2).should be_false
                @course.can_be_updated_by?(@instructor).should be_false
            end
        end

        describe "#can_be_destroyed_by?(user)" do
            it "returns true if user is an admin" do
                @course.can_be_destroyed_by?(@admin).should be_true
            end
            it "returns false if user if not an admin" do
                @course.can_be_destroyed_by?(@user1).should be_false
                @course.can_be_destroyed_by?(@user2).should be_false
                @course.can_be_destroyed_by?(@instructor).should be_false
            end
        end
    end # context
end