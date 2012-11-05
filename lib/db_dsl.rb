# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

##
## Db-manipulation related
##
module DbDsl

  def DbCofAssignment(options={}, &block)
    options ||= { }

    if assignment = find_on_stack(Assignment)
    else
      attrs = FactoryGirl.attributes_for(:assignment);
      attrs[:assignment_plan] = options[:assignment_plan] || DbCofAssignmentPlan(options[:for_assignment_plan])
      attrs[:cohort]          = options[:cohort]          || DbCofCohort(options[:for_cohort])
      assignment = FactoryGirl.create(:assignment, attrs)
    end

    run_block_if_given(assignment,block)
  end

  def DbCofAssignmentExercise(options={}, &block)
    options ||= { }

    if assignment_exercise = find_on_stack(AssignmentExercise)
    else
      attrs = FactoryGirl.attributes_for(:assignment_exercise)
      attrs[:assignment] = options[:assignment] || DbCofAssignment(options[:for_assignment])
      attrs[:topic_exercise] = options[:topic_exercise] || DbCofTopicExercise(options[:for_topic_exercise])
      assignment_exercise = FactoryGirl.create(:assignment_exercise, attrs)
    end

    run_block_if_given(assignment_exercise,block)
  end

  def DbCofAssignmentPlan(options={}, &block)
    options ||= { }

    if options[:existing]
      assignment_plan = AssignmentPlan.where{ name == options[:existing] }.first
    elsif assignment_plan = find_on_stack(AssignmentPlan)
    else
      attrs = FactoryGirl.attributes_for(:assignment_plan)
      attrs[:learning_plan]         = options[:learning_plan] || DbCofLearningPlan(options[:for_learning_plan])
      attrs[:name]                  = options[:name]                  if options[:name]
      attrs[:is_group_work_allowed] = options[:is_group_work_allowed] if options[:is_group_work_allowed]
      attrs[:is_open_book]          = options[:is_open_book]          if options[:is_open_book]
      attrs[:is_ready]              = options[:is_ready]              if options[:is_ready]
      attrs[:is_test]               = options[:is_test]               if options[:is_test]
      attrs[:introduction]          = options[:introduction]          if options[:introduction]
      attrs[:starts_at]             = options[:starts_at]             if options[:starts_at]
      attrs[:ends_at]               = options[:ends_at]               if options[:ends_at]

      attrs[:starts_at] = TimeUtils.timestr_and_zonestr_to_utc_time(attrs[:starts_at], attrs[:learning_plan].klass.time_zone) \
        if attrs[:starts_at].class == String
      attrs[:ends_at] = TimeUtils.timestr_and_zonestr_to_utc_time(attrs[:ends_at], attrs[:learning_plan].klass.time_zone) \
        if attrs[:ends_at].class == String

      assignment_plan = FactoryGirl.create(:assignment_plan, attrs)
    end

    run_block_if_given(assignment_plan,block)
  end

  def DbCofAssignmentPlanTopic(options={}, &block)
    if assignment_plan_topic = find_on_stack(AssignmentPlanTopic)
    else
      attrs = FactoryGirl.attributes_for(:assignment_plan_topic)
      attrs[:assignment_plan] = options[:assignment_plan] || DbCofAssignmentPlan(options[:for_assignment_plan])
      attrs[:topic]           = options[:topic]           || DbCofTopic(options[:for_topic])
      assignment_plan_topic = FactoryGirl.create(:assignment_plan_topic, attrs)
    end

    run_block_if_given(assignment_plan_topic,block)
  end

  def DbCofBasicFeedbackCondition(options={}, &block)
    if feedback_condition = find_on_stack(BasicFeedbackCondition)
    else
      attrs = FactoryGirl.attributes_for(:basic_feedback_condition)
      attrs[:label_regex]                     = options[:label_regex]                     if options[:label_regex]
      attrs[:is_feedback_required_for_credit] = options[:is_feedback_required_for_credit] if options[:is_feedback_required_for_credit]
      attrs[:can_automatically_show_feedback] = options[:can_automatically_show_feedback] if options[:can_automatically_show_feedback]
      attrs[:availability_opens_option]       = options[:availability_opens_option]       if options[:availability_opens_option]
      attrs[:availability_opens_delay_days]   = options[:availability_opens_delay_days]   if options[:availability_opens_delay_days]
      attrs[:availability_closes_option]      = options[:availability_closes_option]      if options[:availability_closes_option]
      attrs[:availability_closes_delay_days]  = options[:availability_closes_delay_days]  if options[:availability_closes_delay_days]
      attrs[:availability_event]              = options[:availability_event]              if options[:availability_event]
      attrs[:learning_condition]              = options[:learning_condition] || DbCofLearningCondition(options[:for_learning_condition])
      feedback_condition = FactoryGirl.create(:basic_feedback_condition, attrs)
    end

    run_block_if_given(feedback_condition,block)
  end

  def DbCofClass(options={}, &block)
    options ||= { }

    if options[:existing]
      klass = Klass.where{ course.name == options[:existing] }.first
    elsif klass = find_on_stack(Klass)
    else
      attrs = FactoryGirl.attributes_for(:klass)
      attrs[:course]  = options[:course]  || DbCofCourse(options[:for_course])
      attrs[:start_date] = options[:start_date] if options[:start_date]
      attrs[:end_date]   = options[:end_date]   if options[:end_date]
      options[:for_instructor] ||= { }
      options[:for_instructor][:course] = attrs[:course]
      attrs[:creator] = options[:creator] || DbCofInstructor(options[:for_instructor]).user

      attrs[:start_date] = TimeUtils.timestr_and_zonestr_to_utc_time(attrs[:start_date], attrs[:time_zone]) \
        if attrs[:start_date].class == String
      attrs[:end_date] = TimeUtils.timestr_and_zonestr_to_utc_time(attrs[:end_date], attrs[:time_zone]) \
        if attrs[:end_date].class == String

      klass = FactoryGirl.create(:klass, attrs)
      klass.sections.first.name = "DELETE THIS SECTION"
      klass.sections.first.save!

      klass.cohorts.first.name = "DELETE THIS COHORT"
      klass.cohorts.first.save!
    end

    run_block_if_given(klass,block)
  end

  def DbCofCohort(options={}, &block)
    options ||= { }

    if options[:existing]
      cohort = Cohort.where{ name == options[:existing] }.first
    elsif cohort = find_on_stack(Cohort)
    else
      attrs = FactoryGirl.attributes_for(:cohort)
      attrs[:klass] = options[:class] || DbCofClass(attrs[:for_class])
      attrs[:name]    = options[:name]    if options[:name]
      attrs[:section] = options[:section] if options[:section]
      attrs[:section] ||= DbCofSection(attrs[:for_section]) if attrs[:for_section]
      attrs[:section] ||= find_on_stack(Section)
      cohort = FactoryGirl.create(:cohort, attrs)

      # Klasses automatically contruct a default Cohort; if the
      # user has specified a custom Cohort, remove the default.
      attrs[:klass].cohorts(true).shift.destroy if attrs[:klass].cohorts(true).first.name == "DELETE THIS COHORT"
    end

    run_block_if_given(cohort,block)
  end

  def DbCofConcept(options={}, &block)
    options ||= { }

    if options[:existing]
      concept = Concept.where{ name == options[:existing] }.first
    elsif concept = find_on_stack(Concept)
    else
      attrs = FactoryGirl.attributes_for(:concept)
      attrs[:name]          = options[:name] if options[:name]
      attrs[:learning_plan] = options[:learning_plan] || DbCofLearningPlan(options[:for_learning_plan])
      concept = FactoryGirl.create(:concept, attrs)
    end

    run_block_if_given(concept,block)
  end

  def DbCofConsentForm(options={}, &block)
    options ||= { }

    if options[:existing]
      consent_form = ConsentForm.where{ name == options[:existing] }.first
    elsif consent_form = find_on_stack(ConsentForm)
    else
      attrs = FactoryGirl.attributes_for(:consent_form)
      attrs[:name]                = options[:name]                if options[:name]
      attrs[:html]                = options[:html]                if options[:html]
      attrs[:esignature_required] = options[:esignature_required] if options[:esignature_required]
      consent_form = FactoryGirl.create(:consent_form, attrs)
    end

    run_block_if_given(consent_form,block)
  end

  def DbCofConsentOptions(options={}, &block)
    options ||= { }

    if consent_options = find_on_stack(ConsentOptions)
    else
      attrs = FactoryGirl.attributes_for(:consent_option)
      attrs[:consent_form]        = options[:consent_form]        || DbCofConsentForm(options[:for_consent_form])
      attrs[:consent_optionable]  = options[:consent_optionable]  || DbCofClass(options[:for_class])         

      # Klasses automatically contruct default ConsentOptions; if the
      # user has specified custom ConsentOptions, remove the default.
      ConsentOptions.where{ consent_optionable_id == attrs[:consent_optionable].id }.first.destroy

      attrs[:opens_at]            = options[:opens_at]   if options[:opens_at]
      attrs[:closes_at]           = options[:closes_at]  if options[:closes_at]

      attrs[:opens_at]  = TimeUtils.timestr_and_zonestr_to_utc_time(attrs[:opens_at],  attrs[:consent_optionable].time_zone) \
        if attrs[:opens_at].class == String
      attrs[:closes_at] = TimeUtils.timestr_and_zonestr_to_utc_time(attrs[:closes_at], attrs[:consent_optionable].time_zone) \
        if attrs[:closes_at].class == String

      consent_options = FactoryGirl.create(:consent_option, attrs)
    end

    run_block_if_given(consent_options,block)
  end

  def DbCofCourse(options={}, &block)
    options ||= { }

    if options[:existing]
      course = Course.where{ name == options[:existing] }.first
    elsif course = find_on_stack(Course)
    else
      attrs = FactoryGirl.attributes_for(:course)
      attrs[:name]         = options[:name] if options[:name]
      attrs[:organization] = options[:organization] || DbCofOrganization(options[:for_organiztion])
      course = FactoryGirl.create(:course, attrs)
    end

    run_block_if_given(course,block)
  end

  def DbCofEducator(options={}, &block)
    options ||= { }

    if educator = find_on_stack(Educator)
    else
      attrs = FactoryGirl.attributes_for(:educator)
      attrs[:klass] = options[:class] || DbCofClass(options[:for_class])
      attrs[:user]  = options[:user]  || DbCofUser(options[:for_user])
      attrs[:is_instructor] = options[:is_instructor] if options[:is_instructor]
      attrs[:is_assistant]  = options[:is_assistant]  if options[:is_assistant]
      attrs[:is_grader]     = options[:is_grader]     if options[:is_grader]
      educator = FactoryGirl.create(:educator, attrs)
    end

    run_block_if_given(educator,block)
  end

  def DbCofExercise(options={}, &block)
    options ||= { }
    if options[:existing]
      exercise = Exercise.where{ url == options[:existing] }.first
    elsif exercise = find_on_stack(Exercise)
    else
      attrs = FactoryGirl.attributes_for(:exercise)
      attrs[:url]           = options[:url]           if options[:url]
      attrs[:is_dynamic]    = options[:is_dynamic]    if options[:is_dynamic]
      attrs[:content_cache] = options[:content_cache] if options[:content_cache]
      exercise = FactoryGirl.create(:exercise, attrs)
    end

    run_block_if_given(exercise,block)
  end

  def DbCofInstructor(options={}, &block)
    options ||= { }

    if instructor = find_on_stack(CourseInstructor)
    else
      attrs = FactoryGirl.attributes_for(:course_instructor)
      attrs[:user]   = options[:user]   || DbCofUser(options[:for_user])
      attrs[:course] = options[:course] || DbCofCourse(options[:for_course])
      instructor = FactoryGirl.create(:course_instructor, attrs)
    end

    run_block_if_given(instructor,block)
  end

  def DbCofLearningCondition(options={}, &block)
    options ||= { }

    if learning_condition = find_on_stack(LearningCondition)
    else
      attrs = FactoryGirl.attributes_for(:learning_condition)
      attrs[:cohort] = options[:cohort] || DbCofCohort(options[:for_cohort])
      learning_condition = FactoryGirl.create(:learning_condition, attrs)

      # Cohorts create a default LearningCondition, so get rid
      # of that one and replace it with the newly created
      # LearningCondition
      attrs[:cohort].learning_condition.destroy
      attrs[:cohort].learning_condition = learning_condition
      attrs[:cohort].save!
    end

    run_block_if_given(learning_condition,block)
  end

  def DbCofLearningPlan(options={}, &block)
    options ||= { }

    if options[:existing]
      learning_plan = LearningPlan.where{ klass.course.name == options[:existing] }.first
    elsif learning_plan = find_on_stack(LearningPlan)
    else
      attrs = FactoryGirl.attributes_for(:learning_plan)
      attrs[:klass]       = options[:class] || DbCofClass(options[:for_class])
      attrs[:name]        = options[:name]        if options[:name]
      attrs[:description] = options[:description] if options[:description]
      learning_plan = FactoryGirl.create(:learning_plan, attrs)

      # Klasses create a default Learning Plan, so get rid
      # of that one and replace it with the newly created
      # Learning Plan. 
      attrs[:klass].learning_plan.destroy
      attrs[:klass].learning_plan = learning_plan
      attrs[:klass].save!
    end

    run_block_if_given(learning_plan,block)
  end

  def DbCofOrganization(options={}, &block)
    options ||= { }

    if options[:existing]
      organization = Organization.where{ name == options[:existing] }.first
    elsif organization = find_on_stack(Organization)
    else
      attrs = FactoryGirl.attributes_for(:organization)
      attrs[:name] = options[:name] if options[:name]
      organization = FactoryGirl.create(:organization, attrs)
    end

    run_block_if_given(organization,block)
  end

  def DbCofPercentScheduler(options={}, &block)
    options ||= { }

    if scheduler = find_on_stack(PercentScheduler)
    else
      attrs = FactoryGirl.attributes_for(:percent_scheduler)
      attrs[:settings]           = options[:settings] if options[:settings]
      attrs[:learning_condition] = options[:learning_condition] || DbCofLearningCondition(options[:for_learning_condition])
      scheduler = FactoryGirl.create(:percent_scheduler, attrs)

      # LearningConditions create a default Scheduler, so get rid
      # of that one and replace it with the newly created
      # PercentScheduler
      attrs[:learning_condition].scheduler.destroy
      attrs[:learning_condition].scheduler = scheduler
      attrs[:learning_condition].save!
    end

    run_block_if_given(scheduler,block)
  end

  def DbCofRegistrationRequest(options={}, &block)
    options ||= { }

    if request = find_on_stack(RegistrationRequest)
    else
      attrs = FactoryGirl.attributes_for(:registration_request)
      attrs[:user]        = options[:user]    || DbCofUser(options[:for_user])
      attrs[:section]     = options[:section] || DbCofSection(options[:for_section])
      attrs[:is_auditing] = options[:is_auditing] if options[:is_auditing]
      request = FactoryGirl.create(:registration_request, attrs)
    end

    run_block_if_given(request,block)
  end

  def DbCofResearcher(options={}, &block)
    options ||= { }

    if researcher = find_on_stack(Researcher)
    else
      attrs = FactoryGirl.attributes_for(:researcher)
      attrs[:user] = options[:user] || DbCofUser(options[:for_user])
      researcher = FactoryGirl.create(:researcher, attrs)
    end

    run_block_if_given(researcher,block)
  end

  def DbCofResource(options={}, &block)
    options ||= { }

    if options[:existing]
      topic = Resource.where{ name == options[:existing] }.first
    elsif resource = find_on_stack(Resource)
    else
      attrs = FactoryGirl.attributes_for(:resource)
      attrs[:topic] = options[:topic] || DbCofTopic(options[:for_topic])
      attrs[:name]  = options[:name] if options[:name]
      attrs[:url]   = options[:url]  if options[:url]
      resource = FactoryGirl.create(:resource, attrs)
    end

    run_block_if_given(resource,block)
  end

  def DbCofSection(options={}, &block)
    options ||= { }

    if options[:existing]
      section = Section.where{ name == options[:existing] }.first
    elsif section = find_on_stack(Section)
    else
      attrs = FactoryGirl.attributes_for(:section)
      attrs[:klass] = options[:class] || DbCofClass(options[:for_class])
      attrs[:name]  = options[:name] if options[:name]
      section = FactoryGirl.create(:section, attrs)

      # Klasses automatically contruct a default Section; if the
      # user has specified a custom Section, remove the default.
      attrs[:klass].sections(true).first.destroy if attrs[:klass].sections(true).first.name == "DELETE THIS SECTION"
    end

    run_block_if_given(section,block)
  end

  def DbCofStudent(options={}, &block)
    options ||= { }

    if student = find_on_stack(Student)
    else
      attrs = FactoryGirl.attributes_for(:student)
      attrs[:user]    = options[:user]    || DbCofUser(options[:for_user])
      attrs[:section] = options[:section] || DbCofSection(options[:for_section])
      attrs[:cohort]  = options[:cohort]  || DbCofCohort(options[:for_cohort])
      student = FactoryGirl.create(:student, attrs)

      if options[:status]
        student.is_auditing = false if options[:status] == :registered
        student.is_auditing = true  if options[:status] == :auditing
        student.drop!               if options[:status] == :dropped
        student.save!
      end
    end

    run_block_if_given(student,block)
  end

  def DbCofStudentAssignment(options={}, &block)
    options ||= { }

    if student_assignment = find_on_stack(StudentAssignment)
    else
      attrs = FactoryGirl.attributes_for(:student_assignment)
      attrs[:student]    = options[:student]    || DbCofStudent(options[:for_student])
      attrs[:assignment] = options[:assignment] || DbCofAssignment(options[:for_assignment])
      student_assignment = FactoryGirl.create(:student_assignment, attrs)
    end
    run_block_if_given(student_assignment,block)
  end

  def DbCofTopic(options={}, &block)
    options ||= { }

    if options[:existing]
      topic = Topic.where{ name == options[:existing] }.first
    elsif topic = find_on_stack(Topic)
    else
      attrs = FactoryGirl.attributes_for(:topic)
      attrs[:learning_plan] = options[:learning_plan] || DbCofLearningPlan(options[:for_learning_plan])
      attrs[:name]          = options[:name] if options[:name]
      topic = FactoryGirl.create(:topic, attrs)
    end

    run_block_if_given(topic,block)
  end

  def DbCofTopicExercise(options={}, &block)
    options ||= { }

    if options[:existing]
      topic_exercise = TopicExercise.where{ name == options[:existing] }.first
    elsif topic_exercise = find_on_stack(TopicExercise)
    else
      attrs = FactoryGirl.attributes_for(:topic_exercise)
      attrs[:name]     = options[:name]     if options[:name]
      attrs[:topic]    = options[:topic]    || DbCofTopic(options[:for_topic])
      attrs[:exercise] = options[:exercise] || DbCofExercise(options[:for_exercise])
      attrs[:concept]  = options[:concept]  || DbCofConcept(options[:for_concept])
      topic_exercise = FactoryGirl.create(:topic_exercise, attrs)
    end

    run_block_if_given(topic_exercise,block)
  end

  def DbCofUser(options={}, &block)
    options ||= { }

    if options[:existing]
      user = User.where{ username == options[:existing] }.first
    elsif user = find_on_stack(User)
    else
      attrs = FactoryGirl.attributes_for(:user)
      attrs[:first_name]        = options[:first_name]  if options[:first_name]
      attrs[:last_name]         = options[:last_name]   if options[:last_name]
      if options[:username] 
        attrs[:username] = options[:username]
      elsif options[:first_name]
        attrs[:username] = options[:first_name].downcase
      end
      attrs[:is_administrator]  = options[:is_admin]    if options[:is_admin]
      user = FactoryGirl.create(:user, attrs)
    end

    run_block_if_given(user,block)
  end

  def DbUniverse
    @db_stack = {}
    yield if block_given?
  end

  def find_on_stack(klass)
    @db_stack[klass] = [] if !@db_stack[klass]
    @db_stack[klass].find_all {|e| e.class == klass}.last
  end

  def push_on_stack(klass, item)
    @db_stack[klass] = [] if !@db_stack[klass]
    @db_stack[klass].push item
  end

  def pop_from_stack(klass)
    @db_stack[klass] = [] if !@db_stack[klass]
    @db_stack[klass].pop
  end

  def run_block_if_given(object,block=nil)
    if block
      push_on_stack object.class, object
      block.call(object)
      pop_from_stack object.class
    end
    object
  end

end
