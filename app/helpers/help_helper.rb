module HelpHelper

  def faq_entry(options, &block)
    options[:section] ||= "General"
    raise IllegalArgument if options[:question].nil?
    @sections ||= ActiveSupport::OrderedHash.new
    @sections[options[:section]] ||= []
    @sections[options[:section]].push({:question => options[:question], :answer => capture(&block)})
  end

end
