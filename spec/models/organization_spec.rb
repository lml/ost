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
                    DbCofOrganization name: "Organization One", force_create: true
                    DbCofOrganization name: "Organization One", force_create: true
                end
            }.to raise_error
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

        describe "#can_be_created_by?" do
            it "returns true if user is an admin" do
                @organization.can_be_created_by?(@admin).should be_true
            end
            it "returns false if user is not an admin" do
                @organization.can_be_created_by?(@user).should be_false
            end
        end

        describe "#can_be_updated_by?" do
            it "returns true if user is an admin" do
                @organization.can_be_updated_by?(@admin).should be_true
            end

            it "returns false if user is not an admin" do
                @organization.can_be_updated_by?(@user).should be_false
            end
        end

        describe "#can_be_destroyed_by?" do
            it "returns true if user is an admin" do
                @organization.can_be_destroyed_by?(@admin).should be_true
            end

            it "returns false if user is not an admin" do
                @organization.can_be_destroyed_by?(@user).should be_false
            end
        end

        describe "#children_can_be_read_by?" do
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