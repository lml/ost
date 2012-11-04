# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource do
    topic
    sequence(:name) {|n| "Resource #{n}"}
    sequence(:url)  {|n| "http://ostresource.com/#{n}"}
    notes "MyText aslkdfj lkafdj lkadjf klajdflk ajdflkaj sdflkaj dlfkjasdlkfj"
  end
end
