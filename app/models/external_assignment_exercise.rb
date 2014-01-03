class ExternalAssignmentExercise < ActiveRecord::Base
  belongs_to :external_assignment
  belongs_to :concept
  belongs_to :topic
  has_many   :student_external_assignment_exercises

  acts_as_numberable container: :external_assignment

  attr_accessible :external_assignment,
                  :student_external_assignment_exercises,
                  :name,
                  :selected_concept,
                  :selected_topic

  def selected_concept
    concept.nil? ? "N/A" : concept.name
  end

  def selected_concept=(concept_pair_id_str)
    concept_pair_id = Integer(concept_pair_id_str)
    if (0 == concept_pair_id)
      self.concept = nil;
    else
      self.concept = external_assignment.klass.learning_plan.concepts[concept_pair_id-1]
    end
  end

  def selected_concept_pairs
    pairs = [];
    pairs << [0, "N/A"]
    external_assignment.klass.learning_plan.concepts.inject(pairs){|pairs,concept| pairs << [pairs.size, concept.name]}
    pairs
  end

  def selected_topic
    topic.nil? ? "N/A" : topic.name
  end

  def selected_topic=(topic_pair_id_str)
    topic_pair_id = Integer(topic_pair_id_str)
    if (0 == topic_pair_id)
      self.topic = nil;
    else
      self.topic = external_assignment.klass.learning_plan.topics[topic_pair_id-1]
    end
  end

  def selected_topic_pairs
    pairs = [];
    pairs << [0, "N/A"]
    external_assignment.klass.learning_plan.topics.inject(pairs){|pairs,topic| pairs << [pairs.size, topic.name]}
    pairs
  end

  def can_be_read_by?(user)
    external_assignment.can_be_read_by?(user)
  end

  def can_be_created_by?(user)
    external_assignment.can_be_created_by?(user)
  end

  def can_be_updated_by?(user)
    external_assignment.can_be_updated_by?(user)
  end

  def can_be_destroyed_by?(user)
    external_assignment.can_be_destroyed_by?(user)
  end

  def can_be_sorted_by?(user)
    can_be_updated_by?(user)
  end

  def children_can_be_read_by?(user, children_symbol)
  end

end
