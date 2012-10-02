
FactoryGirl.define do
  sequence :unique_number, 1 do |n|
    n
  end
  
  sequence :unique_string, 'aaaa' do |abcd|
    abcd
  end
end

def fg_unique_number
  FactoryGirl.generate :unique_number
end

def fg_unique_username(first_name, last_name)
  abc = FactoryGirl.generate :unique_string
  "#{first_name}_#{last_name}_#{abc}"
end

def fg_password
  "password"
end

def fg_unique_last_name
  abc = FactoryGirl.generate :unique_string
  "Lastname#{abc}"
end

def fg_parse_full_name(full_name)
  raise "Invalid user full name: '#{full_name}'" unless %r{(?<fname>\w+)\s+(?<lname>\w+)} =~ full_name
  [fname, lname]
end
