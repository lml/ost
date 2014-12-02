# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'spec_helper'
require 'db_dsl'
include DbDsl

describe Organization do

    context "creation-related features" do
        it "can be created with valid attributes" do
            DbUniverse do
                DbCofOrganization().should be_true
            end
        end
        it "cannot be created without a name" do
            expect {
                attrs = FactoryGirl.attributes_for(:organization)
                attrs[:name] = nil
                organization = Organization.create(attrs)
                organization.save!
            }.to raise_error
        end
        it "cannot be created without a unique name" do
            expect {
                DbUniverse do
                    DbCofOrganization name: "Organization One"
                    DbCofOrganization name: "Organization One"
                end
            }.to raise_error
        end
    end

    context "destruction-related features" do
        it "cannot be destroyed if it has Courses" do
            @organization = nil
            DbUniverse do
                @organization = DbCofOrganization do
                    DbCofCourse()
                    DbCofCourse()
                end
            end
            @organization.courses.size.should eq 2
            @organization.destroy.should eq false
            @organization.errors[:base].should(
              include("Cannot delete an organization that has courses."))
        end
    end

    context "permission-related methods" do

        before(:each) do
            @admin = nil
            @user  = nil
            @organization = nil

            DbUniverse do
                @admin = DbCofUser is_admin: true
                @user  = DbCofUser is_admin: false
                @organization = DbCofOrganization()
            end
        end

        describe "#can_be_created_by?(user)" do
            it "returns true if user is an admin" do
                @organization.can_be_created_by?(@admin).should be_true
            end
            it "returns false if user is not an admin" do
                @organization.can_be_created_by?(@user).should be_false
            end
        end

        describe "#can_be_updated_by?(user)" do
            it "returns true if user is an admin" do
                @organization.can_be_updated_by?(@admin).should be_true
            end

            it "returns false if user is not an admin" do
                @organization.can_be_updated_by?(@user).should be_false
            end
        end

        describe "#can_be_destroyed_by?(user)" do
            it "returns true if user is an admin" do
                @organization.can_be_destroyed_by?(@admin).should be_true
            end

            it "returns false if user is not an admin" do
                @organization.can_be_destroyed_by?(@user).should be_false
            end
        end

        describe "#children_can_be_read_by?(user, children_symbol)" do
            context "children_symbol == :courses" do
                it "returns true if user is an admin" do
                    @organization.children_can_be_read_by?(@admin, :courses).should be_true
                end

                it "returns false if user is not an admin" do
                    @organization.children_can_be_read_by?(@user, :courses).should be_false
                end
            end

            context "children_symbol != :courses" do
                it "returns false if user is an admin" do
                    @organization.children_can_be_read_by?(@admin, :not_courses).should be_false
                end

                it "returns false if user is not an admin" do
                    @organization.children_can_be_read_by?(@user, :not_courses).should be_false
                end
            end
        end

    end # context
end