
# Creates a copy of a Klass for teaching to new students
#
# Inputs:
#
#   1) klass - the Klass to copy
#   2) clone_research_settings - boolean, if true copy klass research settings, 
#        cohorts, consent options (minus form), and learning conditions iff true
#   3) klass open, start, end, and close times (if not provided, reasoanble defaults
#        will be used)
#   4) course - the course to attach this new class to (if not provided existing course used)
#
class CloneKlass

  include Lev::Routine

protected

  def exec(inputs={})

    #######################################################################################
    #
    # Get the input parameters, setting reasonable defaults for those that 
    # are absent

    source_klass = inputs[:klass]

    start_date = inputs[:start_date].presence || Time.now
    end_date   = inputs[:end_date].presence   || start_date + 3.months

    open_date  = inputs[:open_date].presence  || start_date - 2.weeks
    close_date = inputs[:close_date].presence || end_date + 1.month

    clone_research_settings = inputs[:clone_research_settings] || false

    new_course = inputs[:course] || source_klass.course

    #######################################################################################
    #
    # Copy the tree of objects, adjusting parameters as needed (e.g. changing dates).
    # Do not copy over any educators, students, or student data.  Here's the tree of
    # models.
    #
    #   Klass
    #     LearningPlan 
    #       Concepts
    #       Topics
    #         Resources
    #         TopicExercises
    #           NOT Exercises (they are shared)
    #       AssignmentPlans
    #         AssignmentPlanTopics     
    #     Cohorts (iff clone_research_settings)
    #     NOT Sections
    #     Consent Options (iff clone_research_settings)
    #     Learning Conditions (clone iff clone_research_settings, otherwise use defaults)
    #

    # When copying the Klass, change the dates, clear approved emails, attach to the
    # intended course, and toggle the controlled_experiment flag appropriately.

    new_klass = source_klass.dup.tap do |kk|
      kk.approved_emails = nil
      kk.start_date = start_date
      kk.end_date = end_date
      kk.open_date = open_date
      kk.close_date = close_date

      ((kk.enable_admin_controls = true) and (kk.is_controlled_experiment = false)) unless clone_research_settings
      kk.course_id = new_course.id
    end

    # Save the klass to trigger its AR callbacks (creates default section, etc). 
    # Blow away the default learning plan

    new_klass.save!   
    new_klass.learning_plan.destroy

    # Learning Plan

    source_learning_plan = source_klass.learning_plan

    new_learning_plan = source_learning_plan.dup.tap do |lp|
      lp.name = "#{new_course.name} (#{new_klass.start_date.strftime('%b %Y')})"
    end

    new_klass.learning_plan = new_learning_plan
    new_klass.save

    # Concepts - track connection between source and new concepts to properly set associations
    # in topic exercises below

    source_to_new_concept_map = {}

    source_learning_plan.concepts.each do |source_concept|
      new_concept = source_concept.dup
      source_to_new_concept_map[source_concept] = new_concept
      new_learning_plan.concepts << new_concept
    end

    # Topics - track connection between source and new topics to properly set associations
    # in assignment plans below

    source_to_new_topics_map = {}

    source_learning_plan.topics.each do |source_topic|
      new_topic = source_topic.dup
      new_learning_plan.topics << new_topic

      source_to_new_topics_map[source_topic] = new_topic

      # Resources

      source_topic.resources.each do |source_resource|
        new_topic.resources << source_resource.dup
      end

      # TopicExercises

      source_topic.topic_exercises.each do |source_topic_exercise|
        new_topic_exercise = source_topic_exercise.dup
        new_topic_exercise.concept = source_to_new_concept_map[source_topic_exercise.concept]
        new_topic.topic_exercises << new_topic_exercise
      end

      
    end

    # AssignmentPlans

    source_klass_duration = source_klass.end_date - source_klass.start_date
    new_klass_duration = new_klass.end_date - new_klass.start_date

    source_learning_plan.assignment_plans.each do |source_assignment_plan|
      new_assignment_plan = source_assignment_plan.dup.tap do |ap|
        ap.section = new_klass.sections.first
        ap.tag_list = source_assignment_plan.tag_list.join(", ")

        # Map the start and end times to the new klass times

        ap.starts_at = new_klass.start_date + ((ap.starts_at - source_klass.start_date) / source_klass_duration * new_klass_duration)
        ap.ends_at   = new_klass.start_date + ((ap.ends_at   - source_klass.start_date) / source_klass_duration * new_klass_duration)
      end

      # AssignmentPlanTopics

      source_assignment_plan.assignment_plan_topics.each do |source_assignment_plan_topic|
        new_assignment_plan_topic = source_assignment_plan_topic.dup
        new_assignment_plan_topic.topic = source_to_new_topics_map[source_assignment_plan_topic.topic]
        new_assignment_plan.assignment_plan_topics << new_assignment_plan_topic
      end

      new_learning_plan.assignment_plans << new_assignment_plan
    end

    # If we don't want to clone research settings, saving the new_klass above will create
    # a cohort, which will create standard practice learning conditions.  If we do copy
    # research settings, we need to get copies of consent options, cohorts and those cohorts'
    # learning conditions.

    if clone_research_settings
      
      # Consent Options

      new_klass.consent_options = source_klass.consent_options.dup.tap do |new_consent_options|
        new_consent_options.consent_form_id = nil

        new_consent_options.opens_at = new_klass.open_date
        new_consent_options.closes_at = new_klass.close_date
      end

      # Cohorts

      new_klass.cohorts.destroy_all # destroy default cohort
      source_to_new_cohort_map = {}

      source_klass.cohorts.each do |source_cohort|
        new_cohort = source_cohort.dup
        source_to_new_cohort_map[source_cohort] = new_cohort
        new_cohort.section = new_klass.sections.first # we don't copy section
        new_klass.cohorts << new_cohort

        # One LC per Cohort, so take care of it here.

        source_learning_condition = source_cohort.learning_condition
        new_learning_condition = source_learning_condition.dup

        # LC: copy regular and default feedback conditions

        source_learning_condition.learning_condition_feedback_conditions.each do |source_lcfc|
          new_learning_condition.learning_condition_feedback_conditions << source_lcfc.dup.tap do |new_lcfc|
            new_lcfc.feedback_condition = source_lcfc.feedback_condition.dup
          end
        end

        source_lcdfc = source_learning_condition.learning_condition_default_feedback_condition
        new_learning_condition.learning_condition_default_feedback_condition = source_lcdfc.dup.tap do |new_lcdfc|
          new_lcdfc.feedback_condition = source_lcdfc.feedback_condition.dup
        end

        # LC: copy regular and default presentation conditions

        source_learning_condition.learning_condition_presentation_conditions.each do |source_lcpc|
          new_learning_condition.learning_condition_presentation_conditions << source_lcpc.dup.tap do |new_lcpc|
            new_lcpc.presentation_condition = source_lcpc.presentation_condition.dup
          end
        end

        source_lcdpc = source_learning_condition.learning_condition_default_presentation_condition
        new_learning_condition.learning_condition_default_presentation_condition = source_lcdpc.dup.tap do |new_lcdpc|
          new_lcdpc.presentation_condition = source_lcdpc.presentation_condition.dup
        end
      end  

    end # if clone_research_settings

    # Call save to make permanent all of the relations established above.

    new_klass.save! 
    outputs[:new_klass] = new_klass

  end # def exec

end
