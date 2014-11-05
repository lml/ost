class AddIsSurveyToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :is_survey, :boolean, :null => false, :default => false
  end
end
