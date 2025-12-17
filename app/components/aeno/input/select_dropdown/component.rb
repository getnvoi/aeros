module Aeno::Input::SelectDropdown
  class Component < ::Aeno::FormBuilder::BaseComponent
    option(:multiple, default: proc { false })
    option(:searchable, default: proc { false })
    option(:selected_value, optional: true)
    option(:selected_values, default: proc { [] })
    option(:placeholder, default: proc { "Select..." })

    renders_many :options, "OptionComponent"

    class OptionComponent < ::Aeno::ApplicationViewComponent
      option(:value)
      option(:label)
      option(:icon, optional: true)
      option(:selected, default: proc { false })
    end

    def button_label
      if multiple
        return placeholder if selected_values.empty?
        selected_labels = options.select { |opt| selected_values.include?(opt.value.to_s) }.map(&:label)
        return placeholder if selected_labels.empty?
        if selected_labels.size <= 2
          selected_labels.join(", ")
        else
          remaining = selected_labels.size - 2
          "#{selected_labels.first(2).join(", ")} (+#{remaining})"
        end
      else
        selected_option = options.find { |opt| opt.selected || opt.value == selected_value }
        selected_option&.label || placeholder
      end
    end

    def stimulus_values
      {
        "#{controller_name}-multiple-value": multiple,
        "#{controller_name}-name-value": name
      }
    end

    examples("Input Select Dropdown", description: "Dropdown-based select input") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview name: "option"
      end
    end
  end
end
