module Aeno::Input::CheckboxCollection
  class Component < ::Aeno::FormBuilder::BaseComponent
    option(:collection, optional: true)
    option(:value_method, optional: true)
    option(:label_method, optional: true)
    option(:checked_values, default: proc { [] })

    renders_many :options, "OptionComponent"

    class OptionComponent < ::Aeno::ApplicationViewComponent
      option(:value)
      option(:label)
      option(:checked, default: proc { false })
      option(:disabled, default: proc { false })
    end

    examples("Input Checkbox Collection", description: "Checkbox collection input") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview name: "options"
      end
    end
  end
end
