# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# A class for enum values
#
# Usage:
# class SomeClass < Enum
#   SOME_CONSTANT = 0
#   ANOTHER_CONSTANT = 1
# end
#
# Note: do not use the same value more than once,
# or else only the last occurrence will be used
# when searching by value.
class Enum
  # When given a numeric value, returns the constant name
  # When given a name, returns the constant value
  def self.[](val)
    return self.constants.select{|c| self.const_get(c) == val}.last if val.is_a?(Numeric)
    val_sym = val.to_s.gsub(" ", "_").to_sym.upcase
    self.const_defined?(val_sym) ? self.const_get(val_sym) : \
    (self.const_defined?(val_sym.capitalize) ? self.const_get(val_sym.capitalize) : \
    raise(NameError.new("wrong enum name #{val.to_s}")))
  end
  
  # Humanized list of constants
  def self.list
    self.constants.collect{|c| c.to_s.humanize}
  end
  
  # List of constant values
  def self.values
    self.constants.collect{|c| self.const_get(c)}
  end
  
  # Options ready to be used in a select tag
  def self.options
    self.constants.collect{|c| [c.to_s.humanize, self.const_get(c)]}
  end
end
