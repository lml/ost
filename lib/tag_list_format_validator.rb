# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class TagListFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if value.blank?
    tag_array = value.split(",").collect{|t| t.strip}
    object.errors.add(:base, "Illegal label!") if tag_array.empty? && !tags.blank?
    object.errors.add(:base, "No empty labels are allowed") if tag_array.any?{|t| t.blank?}
    object.errors.add(:base, "Labels can only contain letters, numbers, underscores, hyphens, and spaces.") \
      if tag_array.any?{|tag| (tag =~ /^[A-Za-z_\d\- ]+$/).nil?}
  end
end