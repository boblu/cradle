module ApplicationHelper
	def javascript(*args)
		content_for(:javascript) { javascript_include_tag(*args) }
	end
	
	def flash_helper
		inner_divs = [:notice, :alert].inject([]){|ret, item|
			if flash[item]
				ret << content_tag(:div, flash[item], :class => "flash_#{item} span-12")
				flash[item] = nil
			end
			ret
		}.join('\n')
		inner_divs.blank? ? '' : content_tag(:div, inner_divs.html_safe, :class => 'container')
	end
end
