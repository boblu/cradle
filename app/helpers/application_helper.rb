# encoding: utf-8
module ApplicationHelper
	def javascript(*args)
		content_for(:javascript) { javascript_include_tag(*args) }
	end
	
	def stylesheet(*args)
		content_for(:stylesheet) { stylesheet_link_tag(*args) }
	end
	
	def flash_helper
		inner_divs = [:notice, :alert].each_with_object([]){|item, ret|
		  msg = flash.delete(item)
			ret << content_tag(:div, msg, :class => "flash_#{item} span-12") if msg
		}.join('\n')
	  inner_divs.blank? ? '' : content_tag(:div, inner_divs.html_safe, :class => 'container')
	end
	
	def content_header(header)
		content_tag(:div, content_tag(:h3, header), :id => 'content_header_container')
	end
	
	def fancy_submit_button(text)
		content_tag(:button, :type => 'submit', :class => 'minibutton') do
			content_tag(:span, text)
		end
	end

	def fancy_destroy_button(url, msg, remote = nil)
	  confirming = msg.html_safe
	  html_options = {:method => :delete}
	  html_options.update(:remote => remote) if remote
	  confirming << link_to('Yes', url, html_options)
	  confirming << link_to('No', '#', :class => 'negative')
	  confirming = content_tag(:span, confirming, :class => 'confirming')
	  button_content = link_to(content_tag(:span, 'Destroy'), '#', :class => 'minibutton danger')
		button_content << confirming
		content_tag(:span, button_content, :class => 'destroy_button')
	end
	
	# ============
	# = options: =
	# collection, columns, cell_class, cell_style, caption, first_cell_class
	# ============
	def table_for_listing(options, &block)
	  raise ArgumentError, "Missing block" unless block_given?
	  if (collection_size = options[:collection].size) == 0 then ''
    else
	  	options[:columns] ||= 4
	  	options[:cell_class] ||= 'span-5'
      rows = []
      quo, mod = collection_size.divmod(options[:columns])
      1.upto((mod == 0) ? quo*options[:columns] : (quo + 1)*options[:columns]) do |index|
        item = (options[:collection][index-1].blank? ? '' : capture(options[:collection][index-1], &block))
        rows << [] if ((index - 1) % options[:columns] == 0)
        td_class = ((index == 1) ? "#{options[:cell_class]} #{options[:first_cell_class]}" : options[:cell_class])
        rows.last << content_tag(:td, item, :class => td_class, :style => options[:cell_style])
      end
      content_tag(:table, :class => 'listing_table') do
        content_tag(:tr, rows.map{|r| r.join('')}.join('</tr><tr>').html_safe)
      end
    end
  end
end
