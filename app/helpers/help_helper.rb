# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module HelpHelper

  def faq_entry(options, &block)
    options[:section] ||= "General"
    raise IllegalArgument if options[:question].nil?
    @sections ||= ActiveSupport::OrderedHash.new
    @sections[options[:section]] ||= []
    @sections[options[:section]].push({:question => options[:question], :answer => capture(&block)})
  end

  def accordion_entry(options, &block)
    @accordion_entry_count ||= 0

    raise IllegalArgument if options[:title].nil?
    content_tag :div, {:class => 'accordion-group'} do
      @content = content_tag(:div, :class => 'accordion-heading') do
        content_tag :a, :class => 'accordion-toggle', 
                    :'data-toggle' => 'collapse', 
                    :href => "#accordion_entry_#{@accordion_entry_count+=1}" do
          options[:title]
        end
      end
      @content << content_tag(:div, :id => "accordion_entry_#{@accordion_entry_count}",
                                    :class => 'accordion-body collapse') do
        content_tag :div, :class => 'accordion-inner' do
          capture(&block)
        end
      end
    end
 
  end

end
