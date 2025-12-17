module Aeno::Input::Text
  class Component < ::Aeno::FormBuilder::BaseComponent
    option(:autocomplete, optional: true)

    examples("Input Text", description: "Text input field") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview name: "field"
      end
    end
  end
end
