class FixRegistrationRequestSectionIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :registration_requests, [:section_id, :user_id], :unique => true, :name => "index_registration_requests_on_section_id_scoped"
  end

  def down
    remove_index  :registration_requests, :name => "index_registration_requests_on_section_id_scoped"
  end
end
