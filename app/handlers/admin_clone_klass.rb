class AdminCloneKlass
  include Lev::Handler

  paramify :clone_klass do
    attribute :klass_id, type: Integer
    validates :klass_id, presence: true
    attribute :open_date, type: String
    attribute :start_date, type: String
    attribute :end_date, type: String
    attribute :close_date, type: String
    attribute :clone_research_settings, type: boolean
    # validates :clone_research_settings, presence: true
    attribute :course_id, type: Integer
    validates :course_id, presence: true
  end

  uses_routine CloneKlass

protected

  def authorized?
    !caller.nil? && caller.is_administrator?
  end

  def handle

    inputs = clone_klass_params.as_hash(:open_date, :start_date, :end_date, :close_date, :clone_research_settings)
    inputs[:klass] = Klass.find(clone_klass_params.klass_id)
    inputs[:course] = Course.find(clone_klass_params.course_id)

    run(CloneKlass, inputs)
  end

end