
# Defines a new sequence
FactoryGirl.define do
  sequence (:unique_number) {|n| n}
end


def unique_username(first_name, last_name)
  username = "#{first_name}#{last_name}"
  username = username[0,19] if username.length > 20
  username = username + "#{SecureRandom.hex(4)}"
  username.gsub(/[^A-Za-z\d_]/, '')
end
