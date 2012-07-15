module ActsAsNumberable

  def acts_as_numberable(options={})
    configuration = {}
    configuration.update(options) if options.is_a?(Hash)
    
    raise IllegalState.new("Must supply a ':container' option") \
      if configuration[:container].nil?
    
    container_column = configuration[:container].to_s + "_id"
   
    class_eval <<-EOV
      include ActsAsNumberable::InstanceMethods
    
      before_validation :assign_number, :on => :create
      
      validates :number, :uniqueness => { :scope => :#{container_column}, 
                                          :allow_nil => true},
                         :numericality => { :only_integer => true, 
                                            :greater_than => 0,
                                            :allow_nil => true }    

      # When we had nested acts_as_numberables, there were cases where the
      # objects were having their numbers changed (as their peers were being
      # removed from the container), but then when it came time to delete those 
      # objects they still had their old number.  So just reload before
      # destroy.
      before_destroy {self.reload}
      
      after_destroy :mark_as_destroyed
      after_destroy :remove_from_container!
      
      attr_accessor :destroyed
      attr_accessor :changed_sets

      attr_protected :number
    
      def container_column
        '#{container_column}'
      end
      
      def container
        '#{configuration[:container]}'
      end
      
      def self.sort!(sorted_ids)
        items = []
        ActiveRecord::Base.transaction do
          items = find_in_specified_order(sorted_ids)
          
          items.each do |item|
            item.number = nil
            item.save!
          end
          
          items.each_with_index do |item, ii| 
            item.number = ii + 1
            item.save!
          end
        end
        items
      end
    EOV
  end
   
  module InstanceMethods



    def move_to_container!(new_container)
      return if new_container.id == self.send(container_column)
      ActiveRecord::Base.transaction do
        remove_from_container!

        self.send container + "=", new_container
        #self.lesson_exercise_set = new_lesson_exercise_set

        self.assign_number
        self.save!
        self.changed_sets = true
      end
    end

    def remove_from_container!
      # logger.debug("In remove_from_container: " + self.class.name + " " + self.id.to_s)
      
      later_items = self.class.where(container_column => self.send(container_column), 
                                     :number.gt => number)

      # logger.debug("later_items:" + later_items.inspect)
      # logger.debug("is destroyed?: " + self.destroyed.inspect)

      if !self.destroyed
        self.number = nil
        self.send container_column + '=', nil
        self.save!
      end

      # Do this to make sure that the reordering below doesn't 
      # cause a number to be duplicated temporarily (which would
      # cause a validation error)
      later_items.sort_by!{|item| item.number}

      later_items.each do |later|
        later.number = later.number-1
        later.save!
      end
    end

    protected

    def assign_number
      self.number = self.class
                      .where(container_column => self.send(container_column))
                      .count + 1
    end
     
    def mark_as_destroyed
      destroyed = true
    end
    
  end
end
 
ActiveRecord::Base.extend ActsAsNumberable