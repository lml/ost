# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class KlassTest < ActiveSupport::TestCase

  test "clone" do
    time = Time.now

    @klass = FactoryGirl.create :klass, :start_date => time - 5.days, :end_date => time + 3.months - 5.days

    concepts = 3.times.collect{|ii| FactoryGirl.create :concept, :name => "Concept #{ii}", :learning_plan => @klass.learning_plan }

    topic = FactoryGirl.create :topic, :learning_plan => @klass.learning_plan

    exercise = FactoryGirl.create :exercise, url: "https://quadbase.org/questions/q1559v1"

    te = FactoryGirl.create :topic_exercise, :topic => topic, :exercise => exercise, :concept => concepts[0]

    ap = 
      FactoryGirl.create :assignment_plan, 
                         :starts_at => @klass.start_date + 1.week, 
                         :ends_at => @klass.start_date + 2.weeks,
                         :learning_plan => @klass.learning_plan

    FactoryGirl.create :assignment_plan_topic, :topic => topic, :assignment_plan => ap

    FactoryGirl.create :student, :section => @klass.sections.first, :cohort => @klass.cohorts.first

    AssignmentPlan.build_and_distribute_assignments

    new_klass = CloneKlass.call(klass: @klass, clone_research_settings: true).outputs[:new_klass]

    assert_equal new_klass.learning_plan.concepts.count, 3
    assert new_klass.learning_plan.concepts.collect{|c| c.id}.none?{|new_id| concepts.collect{|c| c.id}.include?(new_id)}

  end
end
