module FeaturesHelper
  def show_type_with_related_info(obj)
    case obj.type
    when 'Category'
      "Category (Seperator:#{obj.seperator})"
    else
      obj.type
    end
  end
  
  def show_default_value(obj)
    %w[Id CharNum].exclude?(obj.type) ? obj.default_value : nil
  end
end
