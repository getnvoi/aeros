module Aeno::Checkbox
  class Component < ::Aeno::ApplicationViewComponent
    option(:name)
    option(:value)
    option(:label)
    option(:checked, default: proc { false })
    option(:disabled, default: proc { false })
    option(:description, optional: true)
    option(:id, optional: true)

    def checkbox_id
      id || "#{name}_#{value}".parameterize(separator: "_")
    end

    examples("Checkbox", description: "Single checkbox with label") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview name: "option", value: "1", label: "Option 1"
        e.preview name: "option", value: "2", label: "Option 2", checked: true
        e.preview name: "option", value: "3", label: "Option 3", description: "This is a description"
        e.preview name: "option", value: "4", label: "Option 4", disabled: true
      end
    end
  end
end
