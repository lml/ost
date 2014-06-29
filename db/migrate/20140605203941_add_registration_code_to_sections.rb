class AddRegistrationCodeToSections < ActiveRecord::Migration
  def up
    add_column :sections, :registration_code, :string
    add_index :sections, :registration_code, unique: true

    Section.all.each{|section| section.reset_registration_code!}
  end

  def down
    remove_index :sections, :registration_code
    remove_column :sections, :registration_code
  end
end
