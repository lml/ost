class AddIsControlledExperimentToKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :is_controlled_experiment, :boolean, :null => false, :default => false
  end
end
