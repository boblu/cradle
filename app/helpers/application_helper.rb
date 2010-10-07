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
end
