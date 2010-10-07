# encoding: utf-8
module DomainsHelper
  def domain_label_and_number(domain)
    span_num = content_tag(:span, damain_dic_display_number(domain), :id => "domain_label_#{domain.id}_dic_num")
    content_tag(:span, (domain.label + span_num).html_safe, :id => "domain_label_#{domain.id}")
  end
  
  def damain_dic_display_number(domain)
    ((x = domain.dictionaries.size) > 0) ? " (#{x})" : ''
  end
end
