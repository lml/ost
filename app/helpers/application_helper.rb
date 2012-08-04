module ApplicationHelper
  include Ost::Utilities
  
  def alert_tag(messages)
    attention_tag(messages, :alert)
  end
  
  def notice_tag(messages)
    attention_tag(messages, :notice)
  end
  
  def attention_tag(messages, type)
    return if messages.blank? || messages.empty?
    messages = Array.new(messages).flatten
    
    div_class = type == :alert ? "ui-state-error" : "ui-state-highlight"
    icon_class = type == :alert ? "ui-icon-alert" : "ui-icon-info"
    
    content_tag :div, :class => "ui-widget" do
      content_tag :div, :class => "#{div_class} ui-corner-all", 
                        :style => "margin: 10px 0px; padding: 0 .7em;" do
        content_tag :p do
          content_tag(:span, "", :class => "ui-icon #{icon_class}",
                             :style => "float:left; margin-right: .3em;") +
          (type == :alert ? content_tag(:strong, "Alert: ") : "") +

          (messages.size == 1 ? 
           messages.first : 
           ("<ul>"+messages.collect{|a| "<li>"+a+"</li>"}.join("")+"</ul>").html_safe)
        end
      end
    end
  end
  
  def full_name_link(user)
    text = (user_signed_in? && current_user.id == user.id) ? "Me" : user.full_name
    link_to text, user
  end
  
  def tf_to_yn(bool)
    bool ? "Yes" : "No"
  end
  
  def block_to_partial(partial_name, options={}, &block)
    options[:classes] ||= []
    options.merge!(:body => capture(&block))
    render(:partial => partial_name, :locals => options)
  end
    
  def pageHeading(heading_text, options={})
    options[:take_out_site_name] = true if options[:take_out_site_name].nil?
    options[:sub_heading_text] ||= ""
    options[:title_text] ||= heading_text + (options[:sub_heading_text].blank? ? 
                                             "" : 
                                             " [#{options[:sub_heading_text]}]")
    
    @page_title = options[:title_text]
    @page_title.sub!(SITE_NAME,"").strip! if @page_title.include?(SITE_NAME) && options[:take_out_site_name]
    
    return if heading_text.blank?
    
    content_for :page_heading do
      render(:partial => 'shared/page_heading', 
             :locals => {:heading_text => heading_text, 
                         :sub_heading_text => options[:sub_heading_text]})
    end
    
  end
  
  def important(text, options={})
    content_for :important do
      render(:partial => 'shared/important', 
             :locals => {:text => text,
                         :options => options})
    end
  end
    
  def section(title, options={}, &block)
    block_to_partial('shared/section', options.merge(:title => title), &block)
  end
  
  def sub_section(title, options={}, &block)
    block_to_partial('shared/sub_section', options.merge(:title => title), &block)
  end
  
  def please_wait_js
    '$(this).blur().hide().parent().append("Please wait");'
  end
  
  def ej(text)
    escape_javascript(text)
  end
  
  def gravatar_url_for(email, options = {})
    options[:secure] ||= request.ssl?
    options[:size] ||= 50
    
    hash = Digest::MD5.hexdigest(email)
    base = options[:secure] ? "https://secure" : "http://www"
      
    "#{base}.gravatar.com/avatar/#{hash}?s=#{options[:size]}"
  end
  
  def gravatar_image(user, options = {}) 
    gravatar_image_by_email(user.email, options)
  end
  
  def gravatar_image_by_email(email, options={})
    image_tag(gravatar_url_for(email, options), 
              { :alt => "User Avatar", 
                :title => "User Avatar",
                :border => 1 })
  end
  
  def link_to_help(topic, text="", options={})
    @include_help_dialog = true
    @include_mathjax = true if options[:include_mathjax]
    
    @options = options
    
    link_to (text.blank? ? image_tag('help_button_v2.png') : text), 
            topic_help_path(topic, :options => options), 
            :remote => true
  end
  
  def standard_date(datetime)
    datetime.nil? ? "" : datetime.strftime(STANDARD_DATE_FORMAT)
  end
  
  def standard_datetime(datetime)
    datetime.nil? ? "" : datetime.strftime(STANDARD_DATETIME_FORMAT)
  end
  
  def standard_datetime_zone(datetime, zone)
    datetime.nil? ? "" : datetime.in_time_zone(zone).strftime(STANDARD_DATETIME_FORMAT + " %Z")
  end
  
  def month_year(datetime)
    datetime.nil? ? "" : datetime.strftime("%B %Y")
  end
  
  def show_button(target)
    link_to("", target, :class => "icon_only_button show_button")
  end
  
  def edit_button(target, options={})
    @edit_button_count = (@edit_button_count || -1) + 1
    
    options[:remote] ||= false
    options[:small] ||= false
    options[:id] ||= "edit_button_#{@edit_button_count}"
    
    klass = "edit_button icon_only_button" + (options[:small] ? "_small" : "")
    
    link_to "", target.nil? ? nil : edit_polymorphic_path(target), :class => klass, :id => options[:id], :remote => options[:remote]
  end
  
  def trash_button(target, options={})
    @trash_button_count = (@trash_button_count || -1) + 1
    
    options[:confirm] ||= "Are you sure?"
    options[:remote] ||= false
    options[:small] ||= false
    options[:id] ||= "trash_button_#{@trash_button_count}"
    
    klass = "trash_button icon_only_button" + (options[:small] ? "_small" : "")
    link_to '', target, 
                :id => options[:id],
                :class => klass,
                :confirm => options[:confirm], 
                :method => :delete, 
                :remote => options[:remote]
  end

  def none_row(table_id, items_array, num_columns)
    output = "<tr id=\"#{table_id}_none_row\""
    output << " style=\"display:none\"" if !items_array.empty?
    output << "><td colspan=\"#{num_columns}\"><center>None</center></td></tr>"
    output.html_safe
  end
  
  def protect_form
    javascript_include_tag 'protect_form'
  end
  
  def uber_list(entries, entry_text_method=nil, options={}, &entry_text_block)
    
    options[:hide_edit] ||= false
    options[:hide_trash] ||= false
    options[:remote_buttons] ||= false
    
    @uber_list_count = (@uber_list_count ||= 0) + 1
    uber_list_id_num = options[:list_number] || @uber_list_count
    @uber_list_id = "uber_list_#{uber_list_id_num}"
    
    if !options[:sort_path].nil?
      content_for :javascript do
        javascript_tag do
          "$('##{@uber_list_id}').sortable({
             dropOnEmpty: false,
             handle: '.handle',
             items: 'div.sortable_item_entry',
             opacity: 0.7,
             scroll: true,
             update: function(){
                $.ajax({
                   type: 'post',
                   data: $('##{@uber_list_id}').sortable('serialize'),
                   dataType: 'script',
                   url: '#{options[:sort_path]}'
                });
             }
          }).disableSelection();"
        end
      end
    end
    
    content_for :javascript do
      javascript_tag do
          "$('.sortable_item_entry').live('mouseenter mouseleave', function(event) {
              $(this).children('.sortable_item_buttons:first')
                     .css('display', event.type == 'mouseenter' ? 'inline-block' : 'none');
          });"      
      end
    end

    bullet_class = options[:sort_path].nil? ? 'ui-icon-triangle-1-e' : 'ui-icon-arrow-4'

    content_tag :div, :id => "#{@uber_list_id}", :class => options[:class], :style => options[:style] do
      content_tag(:div, "None", :style => "#{!entries.empty? ? 'display:none' : ''}") +
      
      entries.collect { |entry|
        content_tag :div, :id => "sortable_item_#{entry.id}", 
                          :class => 'sortable_item_entry', 
                          :style => "height:24px;" do

          a = content_tag(:span, "", :class => "ui-icon #{bullet_class} handle",
                                 :style => 'display:inline-block; height: 14px')
          
          b = content_tag(:div, {:style => 'display:inline-block'}, :escape => false) do
            link_text = entry_text_method.nil? ? 
                        entry_text_block.call(entry) :
                        entry.send(entry_text_method)
            link_target = options[:link_target_method].nil? ?
                          entry : 
                          entry.send(options[:link_target_method])
            link_target = options[:namespace].nil? ? 
                          link_target : 
                          [options[:namespace], link_target]
                          
            link_to(link_text.blank? ? 'unnamed' : link_text, link_target)
          end
          
          c = content_tag(:div, {:class => "sortable_item_buttons", 
                             :style => 'padding-left: 8px; display:none; vertical-align:top'},
                            :escape => false) do
            button_target = options[:namespace].nil? ? 
                            entry : 
                            [options[:namespace], entry]
            (options[:hide_edit] ? "".html_safe : edit_button(button_target, {:small => true, :remote => options[:remote_buttons]})) +
            (options[:hide_trash] ? "".html_safe : trash_button(button_target, {:small => true, :remote => options[:remote_buttons]}))
          end

          a+b+c
        end
      }.join("").html_safe   
    end  
  end

  def simple_root_url
    root_url({:protocol => 'http'}).chop
  end
  
  def email_link(addressee, text)
    domain = ""
    if text =~ /([A-Z_\-0-9]+)@openstaxtutor\.org/i
      text = ($1+content_tag(:span, "_nospam_", :class => 'antispam')).html_safe
      domain = (content_tag(:span, '&#064;openst'.html_safe) + content_tag(:span, "axtutor.org")).html_safe
    end
    
    @iframe_counter = (@iframe_counter || 0) + 1
    (link_to((text+domain).html_safe, write_path(:to => addressee), {:target => "rm#{@iframe_counter}", :method => :post})  + 
    "<iframe name=rm#{@iframe_counter} width=1 height=1 frameborder=0 scrolling=no style=\"visibility:hidden;\"></iframe>".html_safe)
  end
  
  def mark_required
    content_tag :span, " *", :class => 'required'
  end

  def hide_email(email)
    domain = email.split('@')[1]
    if domain.nil?
      return '***'
    end
    return '***@' + domain
  end
  
  def auth_only(text)
    user_signed_in? ? text : "[ hidden ]"
  end
  
  def site_name
    SITE_NAME
  end
  
  def a_site_name
    "an #{SITE_NAME}"
  end
 
  # A shorthand way to add nav items to the right hand column
  # alpha can be a boolean and args can be left out
  #  or
  # alpha can be a symbol representing a method and args are the args
  #
  # In the latter case, the method is called and the result should be
  # a boolean (which gets us to the first case)
  #
  # If the boolean is true, the contents of block are added to the right hand 
  # column
  def navitem(alpha = true, *args, &block)
    @navitems ||= []
    
    if alpha.class == Symbol
      case args.size
      when 0
        alpha = present_user.send(alpha)
      when 1
        alpha = present_user.send(alpha, args.first)
      else
        alpha = present_user.send(alpha, *args)
      end
    end
    
    if alpha
      @navitems.push(capture(&block))
    end
  end
  
  def enable_best_in_place
    return if @best_in_place_already_set
    
    content_for :javascript do
      javascript_tag do
        "$(document).ready(function() {
          $(\'.best_in_place\').best_in_place();
          
          $('.best_in_place').ajaxError(function(e, jqxhr, settings, exception) {
            var obj = jQuery.parseJSON(jqxhr.responseText);
            open_message_dialog(true, 100, 300, 'Error!', obj.toString());
          });
        });"
      end
    end
    
    @best_in_place_already_set = true
  end

  
end
