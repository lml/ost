# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


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
