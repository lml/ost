
class ClassesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]
  before_filter :get_course, :only => [:new, :create]
  before_filter :set_time_zone, :only => [:create, :update]
  before_filter :enable_clock

  def index
    @klasses = Klass.where{end_date > Time.zone.now}
  end

  def show
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@klass)
    turn_on_consenting(@klass.student_for(present_user))
  end

  def new
    @klass = Klass.new
    @klass.course = @course

    redirect_to catalog_path, :alert => "A manager at #{@course.organization.name} needs to give you permission to teach this class." \
      unless present_user.can_create?(@klass)
  end

  def help; end

  def edit
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@klass)
  end

  def create
    @klass = Klass.new(params[:klass])
    @klass.course = @course
    @klass.creator = present_user
    raise SecurityTransgression unless present_user.can_create?(@klass)    

    respond_to do |format|
      if @klass.save
        format.html { redirect_to @klass, notice: 'Class was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@klass)
    @klass.enable_admin_controls = present_user.is_administrator?

    respond_to do |format|
      if @klass.update_attributes(params[:klass])
        format.html { redirect_to @klass, notice: 'Class was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@klass)
    @klass.destroy
    redirect_to klasses_url
  end
  
  def preview_assignments
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@klass.learning_plan)
    
    @assignments = []
    
    # We probably have to save assignments during this "preview" so do it
    # in a transaction so we can roll everything back.
    Klass.transaction do
    
      @cohorts = @klass.cohorts
      learning_conditions = @cohorts.collect{|c| c.learning_condition}
    
      # Iterate through learning plans, building up assignments
      @klass.learning_plan.assignment_plans.each do |assignment_plan|
        @assignments.push([])

        # Iterate through the cohorts, pushing the assignments for them onto the list
        @cohorts.each_with_index do |cohort, cc|
          
          next if !assignment_plan.applies_to_klass_cohort?(cohort)
          
          # If this assignment plan has already had an assignment built for it
          # (because it has already been sent out) use it; otherwise, make it
          
          assignment = cohort.assignments.where{assignment_plan_id == assignment_plan.id}.first
          
          if assignment.nil?
            learning_condition = learning_conditions[cc]
            assignment = learning_condition.build_assignment(assignment_plan)
            assignment.dry_run = true
            assignment.save
          end
          
          @assignments.last.push(assignment)
        end
      end   
    
      raise ActiveRecord::Rollback
    end   
       
  end
  
  def report
    @klass = Klass.find(params[:id])
        
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :report)
    
    respond_to do |format|
      # format.csv
      format.xls
    end
  end
  
  def class_grades
    @klass = Klass.find(params[:id])

    raise SecurityTransgression unless present_user.can_read_children?(@klass, :class_grades)

    respond_to do |format|
      format.xls
    end
  end
    
protected

  def get_course
    @course = Course.find(params[:course_id])
  end

  def set_time_zone
    Time.zone = params[:klass][:time_zone]
  end

end
