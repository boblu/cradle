class TrueClass
  def yesno
    "Yes"
  end
end

class FalseClass
  def yesno
    "No"
  end
end

# =================================================
# = add required mark to form label automatically =
# =================================================
module ActionView
  module Helpers
    module InstanceTagMethods
      def to_label_tag(text = nil, options = {}, &block)
        options = options.stringify_keys
        tag_value = options.delete("value")
        name_and_id = options.dup

        if name_and_id["for"]
          name_and_id["id"] = name_and_id["for"]
        else
          name_and_id.delete("id")
        end

        add_default_name_and_id_for_value(tag_value, name_and_id)
        options.delete("index")
        options["for"] ||= name_and_id["id"]

        if block_given?
          label_tag(name_and_id["id"], options, &block)
        else
          content = if text.blank?
            I18n.t("helpers.label.#{object_name}.#{method_name}", :default => "").presence
          else
            text.to_s
          end
          
          content ||= if object && object.class.respond_to?(:human_attribute_name)
            object.class.human_attribute_name(method_name)
          end
          
          content ||= method_name.humanize

          content << ' *' if object && object.class.validators_on(method_name).map(&:class).include?(ActiveModel::Validations::PresenceValidator)

          label_tag(name_and_id["id"], content, options)
        end
      end
    end
  end
end