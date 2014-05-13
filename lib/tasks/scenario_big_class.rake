# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

namespace :db do
  namespace :scenario do
  
    task :big_class => "db:scenario:full_learning_plan" do
      Cohort.all.each do |c|
        puts "Cohort ##{c.id}"

        puts 'Creating students'
        15.times do |i|
          n = 15*c.id + i - 14
          u = User.new
          u.username = "student#{n}"
          u.first_name = "Student"
          u.last_name = n.to_s
          u.email = "student#{n}@example.com"
          u.password = "password"
          u.save!

          s = Student.new
          s.section = Section.first
          s.user = u
          s.cohort = c
          s.is_auditing = false
          s.save!
        end

        puts 'Creating assignments'
        AssignmentPlan.all.each do |ap|
          a = Assignment.new
          a.assignment_plan = ap
          a.cohort = c
          a.save!

          c.students.each do |s|
            sa = StudentAssignment.new
            sa.student = s
            sa.assignment = a
            sa.save!
          end
        end

      end

      puts 'Creating concepts'
      10.times do |i|
        c = Concept.new
        c.name = "Concept #{i}"
        c.learning_plan = LearningPlan.first
        c.save!
      end

      puts 'Creating exercises, assigning them and faking student responses'
      Exercise.all.each do |e|
        te = TopicExercise.new
        te.exercise = e
        te.topic_id = rand(4) + 1
        te.concept_id = rand(10) + 1
        te.save!

        ae = AssignmentExercise.new
        ae.topic_exercise = te
        ae.assignment_id = rand(6) + 1
        ae.save!

        ae.assignment.student_assignments.each do |sa|
          se = StudentExercise.new
          se.student_assignment = sa
          se.assignment_exercise = ae
          se.save!

          3.times do |i|
            fr = FreeResponse.new
            fr.student_exercise = se
            fr.type = 'TextFreeResponse'
            fr.content = "Answer ##{rand(10000)}"
            fr.save!

            rt = ResponseTime.new
            rt.response_timeable = se
            rt.event = ["STARTED", "STOPPED", "HEARTBEAT", "ACTIVITY", "LINKCLICK", "TIMEOUT"].sample
            rt.save!
          end
        end
      end

    end

  end
end
