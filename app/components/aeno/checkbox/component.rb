module Aeno::Checkbox
  class Component < ::Aeno::ApplicationViewComponent
    option(:name)
    option(:value)
    option(:checked, default: proc { false })
    option(:disabled, default: proc { false })
    option(:id, optional: true)
    option(:data, optional: true, default: proc { {} })
    option(:aria, optional: true, default: proc { {} })
    option(:css, optional: true)

    def checkbox_id
      id || "#{name}_#{value}".parameterize(separator: "_")
    end

    def checkbox_classes
      [
        "col-start-1 row-start-1 appearance-none rounded-button-sm border border-gray-300 bg-white",
        "checked:border-primary-solid checked:bg-primary-solid",
        "indeterminate:border-primary-solid indeterminate:bg-primary-solid",
        "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-solid",
        "disabled:border-gray-300 disabled:bg-gray-100 disabled:checked:bg-gray-100",
        "forced-colors:appearance-auto",
        css
      ].compact.join(" ")
    end

    examples("Checkbox", description: "Bare checkbox input") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview name: "option", value: "1"
        e.preview name: "option", value: "2", checked: true
        e.preview name: "option", value: "3", disabled: true
      end
    end
  end
end
