
# Defines a new sequence
FactoryGirl.define do
  sequence (:unique_number) {|n| n}
end


def unique_username(first_name, last_name)
  "#{first_name[0,3]}#{last_name[0,4]}" + "#{SecureRandom.hex(4)}"
end
