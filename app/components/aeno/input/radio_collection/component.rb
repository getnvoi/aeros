module Aeno::Input::RadioCollection
  class Component < ::Aeno::FormBuilder::BaseComponent
    option(:collection, optional: true)
    option(:value_method, optional: true)
    option(:label_method, optional: true)
    option(:checked_value, optional: true)

    renders_many :options, "OptionComponent"

    class OptionComponent < ::Aeno::ApplicationViewComponent
      option(:value)
      option(:label)
      option(:checked, default: proc { false })
      option(:disabled, default: proc { false })
    end

    examples("Input Radio Collection", description: "Radio collection input") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview name: "option"
      end
    end
  end
end
