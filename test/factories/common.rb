
# Defines a new sequence
FactoryGirl.define do
  sequence (:unique_number) {|n| n}
end


def unique_username(first_name, last_name)
  "#{first_name}#{last_name}" + "#{SecureRandom.hex(4)}"
end
